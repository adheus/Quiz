//
//  MainViewController.swift
//  Quiz
//
//  Created by Adheús Rangel on 12/08/19.
//  Copyright © 2019 Adheus Rangel. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate, QuizManagerObserver {
    
    let kGuessesCounterFormat = "%02d/%02d"
    let kTimerFormat = "%02d:%02d"
    
    @IBOutlet var quizTitleLabel:UILabel!
    @IBOutlet var guessTextField:UITextField!
    @IBOutlet var guessesTableView:UITableView!
    @IBOutlet var guessesCountLabel:UILabel!
    @IBOutlet var quizTimerLabel:UILabel!
    @IBOutlet var actionButton:UIButton!
    
    private var quizManager:QuizManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.quizManager = QuizManager(quizInfo: QuizInfo())
        
        // Do any additional setup after loading the view.
        self.quizManager?.observer = self
        self.quizTitleLabel.text = self.quizManager?.quizInfo.question
        
        self.quizManager?.reset()
    }


    @IBAction func onActionPressed(_ sender:UIButton!) {
        if let state = self.quizManager?.state {
            switch(state) {
            case QuizManager.State.Ready:
                self.quizManager?.start()
                break
            default:
                self.quizManager?.reset()
                break
            }
        }
    }
    
    // MARK: UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldString = textField.text {
            let newString = oldString.replacingCharacters(in: Range(range, in: oldString)!,
                                                          with: string)
            print("Trying to guess: \(newString)")
            if let correct = self.quizManager?.guess(newString), correct {
                self.guessTextField.text = ""
                return false
            }
        }
       
        return true
    }
    
    
    // MARK: UITableViewDataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.quizManager?.correctGuesses.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let guessTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GuessTableViewCell") as! GuessTableViewCell
        guessTableViewCell.setupFor(guess: self.quizManager?.correctGuesses[indexPath.row] ?? "")
        return guessTableViewCell
    }
    
    // MARK: QuizManagerObserver
    
    func onQuizTimeUpdate(remainingTimeInSeconds: Int) {
        let minutes = remainingTimeInSeconds / 60
        let seconds = remainingTimeInSeconds - (minutes * 60)
        
        let timeString = String(format:"%02d:%02d", minutes, seconds)
        self.quizTimerLabel.text = timeString
    }
    
    func onQuizCorrectGuessesCountChanged(currentCount: Int, total: Int) {
        if currentCount > 0 {
            self.guessesTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.left)
        } else {
            self.guessesTableView.reloadData()
        }
        self.guessesCountLabel.text = String(format:kGuessesCounterFormat, currentCount, total)
    }
    
    func onQuizStateChanged(state: QuizManager.State) {
        
        var buttonTitle = "Reset"
        if state == QuizManager.State.Ready {
            buttonTitle = "Start"
        }
        
        self.actionButton.setTitle(buttonTitle, for: .normal)
    }
}

