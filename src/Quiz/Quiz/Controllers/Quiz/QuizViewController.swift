//
//  MainViewController.swift
//  Quiz
//
//  Created by Adheús Rangel on 12/08/19.
//  Copyright © 2019 Adheus Rangel. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate, ErrorViewDelegate {
    
    let kGuessesCounterFormat = "%02d/%02d"
    let kTimerFormat = "%02d:%02d"
    
    @IBOutlet var quizTitleLabel:UILabel!
    @IBOutlet var guessTextField:UITextField!
    @IBOutlet var guessesTableView:UITableView!
    @IBOutlet var guessesCountLabel:UILabel!
    @IBOutlet var quizTimerLabel:UILabel!
    @IBOutlet var actionButton:UIButton!
    
    @IBOutlet var footerView:UIView!
    @IBOutlet var footerBottomConstraint:NSLayoutConstraint!
    
    @IBOutlet var loadingViewContainer:UIView!
    @IBOutlet var loadingView:LoadingView!
    
    @IBOutlet var errorView:ErrorView!
        
    private var quizViewModel:QuizViewModel = QuizViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Setup UITapGestureRecognizer to dismiss keyboard [AR]
        let hideKeyboardGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clearKeyboard))
        self.view.addGestureRecognizer(hideKeyboardGestureRecognizer)
        hideKeyboardGestureRecognizer.cancelsTouchesInView = false
        
        self.registerForKeyboardNotifications()
        self.registerForAppMovedToForeground()
        
        self.errorView.delegate = self
        self.guessesTableView.tableFooterView = UIView()
        
        self.quizViewModel.viewStateObserver = self.onViewModelStateChanged
        self.quizViewModel.onViewLoaded()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.unregisterForKeyboardNotifications()
    }
   
    func onViewModelStateChanged() {
        
        switch self.quizViewModel.viewState {
        case .Loading:
            self.showLoadingView()
            self.guessTextField.isHidden = true
            self.hideErrorView()
            break
        case .Error:
            self.hideLoadingView()
            self.showErrorView()
            break
        default:
            self.guessTextField.isHidden = false
            self.hideErrorView()
            self.hideLoadingView()
        }
        
        self.quizTitleLabel.text = self.quizViewModel.quizTitleText
        
        self.guessTextField.text = self.quizViewModel.guessTextFieldText
        // if GuessTextField changed to enabled, force keyboard appeareance.
        if self.guessTextField.isEnabled != self.quizViewModel.guessTextFieldEnabled && self.quizViewModel.guessTextFieldEnabled {
            self.guessTextField.isEnabled = self.quizViewModel.guessTextFieldEnabled
            self.guessTextField.becomeFirstResponder()
        } else {
            self.guessTextField.isEnabled = self.quizViewModel.guessTextFieldEnabled
        }
        self.guessesCountLabel.text = self.quizViewModel.guessesCounterText
        self.quizTimerLabel.text = self.quizViewModel.remainingTimeLabelText
        self.actionButton.setTitle(self.quizViewModel.actionButtonTitle, for: .normal)
        
        switch(self.quizViewModel.tableViewAction) {
        case .ReloadData:
            self.guessesTableView.reloadData()
            self.quizViewModel.consumeTableViewAction()
            break
        case .AnimateInsertion:
            self.guessesTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
            self.quizViewModel.consumeTableViewAction()
            break
        case .None:
            break
        }
        
        switch self.quizViewModel.dialogState {
        case .Show(let title, let message, let button):
            self.showDialog(title: title, message: message, button: button)
            break
        default:
            break
        }
    }

    @IBAction func onActionPressed(_ sender:UIButton!) {
        self.quizViewModel.onActionButtonPressed()
    }
    
    // MARK: Dialog methods
    
    private func showDialog(title:String, message:String, button:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: button, style: .default, handler: { action in
            self.quizViewModel.onDialogDismissed()
        }))
        
        self.present(alert, animated: true)
    }
    
    
    // MARK: Loading view methods
    
    private func showLoadingView() {
        self.loadingViewContainer.showAnimated()
        self.loadingView.isLoading = true
    }
    
    private func hideLoadingView() {
        self.loadingViewContainer.hideAnimated()
        self.loadingView.isLoading = false
    }
    
    // MARK: Error view methods
    
    private func showErrorView() {
        self.errorView.showAnimated()
    }
    
    private func hideErrorView() {
        self.errorView.hideAnimated()
    }
    
    
    // MARK: ErrorViewDelegate methods
    
    func retry() {
        self.quizViewModel.onViewLoaded()
    }
    
    // MARK: UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldString = textField.text {
            let newString = oldString.replacingCharacters(in: Range(range, in: oldString)!,
                                                          with: string)
            self.quizViewModel.performGuess(guess: newString)
            return false
        }
       
        return true
    }
    
    // MARK: UITableViewDataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.quizViewModel.correctGuesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let guessTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GuessTableViewCell") as! GuessTableViewCell
        guessTableViewCell.setupFor(guess: self.quizViewModel.correctGuesses[indexPath.row])
        return guessTableViewCell
    }
    
    // MARK: Keyboard visibility methods
    
    @objc func keyboardWillShow(sender: NSNotification) {
        // Dot not change constraint if device is in landscape mode
        if [UIDeviceOrientation.landscapeLeft, UIDeviceOrientation.landscapeRight].contains(UIDevice.current.orientation) {
            return
        }
        
        let info = sender.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        self.footerBottomConstraint.constant = keyboardSize - self.view.safeAreaInsets.bottom
        let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        let info = sender.userInfo!
        let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        self.footerBottomConstraint.constant = -44
        
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func clearKeyboard() {
        self.guessTextField.resignFirstResponder()
    }
    
    // MARK: Orientaion handling methods
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let isLandscape = size.width > size.height
        // Restore footer constraint if device is in landscape mode [AR]
        if isLandscape {
            self.footerBottomConstraint.constant = -44
        }
    }
    
    // MARK: Background / Foreground handling methods
    
    func registerForAppMovedToForeground() {
        NotificationCenter.default.addObserver(self, selector: #selector(appBackToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func appBackToForeground() {
        self.quizViewModel.resume()
    }
}

