//
//  QuizViewModel.swift
//  Quiz
//
//  Created by Adheús Rangel on 13/08/19.
//  Copyright © 2019 Adheus Rangel. All rights reserved.
//

import Foundation
class QuizViewModel : QuizManagerObserver {
    
    enum ViewState {
        case Idle, Loading, Error, Ready
    }
    
    enum UITableViewAction {
        case None, ReloadData, AnimateInsertion
    }
    
    enum DialogState {
        case Dismissed
        case Show(title: String, message: String, button: String)
        
        static func Victory() -> DialogState {
           return  DialogState.Show(title: "Congratulations",
                             message: "Good job! You found all the answers on time. Keep up with the great work.",
                             button: "Play again")
        }
        
        static func Defeated(count:Int, total:Int) -> DialogState {
            return  DialogState.Show(title: "Time finished",
                                     message: String(format: "Sorry, time is up! You got %d out of %d answers.", count, total),
                                     button: "Try again")
        }
        
        static func Restart() -> DialogState {
            return  DialogState.Show(title: "Heey! Where did you go?",
                                     message: "That's not fair! Your quiz will be restarted.",
                                     button: "OK")
        }
    }
    
    typealias QuizViewModelStateObserver = () -> Void
    
    let kGuessesCounterFormat = "%02d/%02d"
    let kTimerFormat = "%02d:%02d"
    
    var quizManager: QuizManager? = nil {
        didSet {
            if let quizManager = self.quizManager {
                self.viewState = .Ready
                quizManager.observer = self
                self.quizTitleText = quizManager.quizInfo.question
                quizManager.reset()
            }
        }
    }
    
    /*
      Current view state
    */
    private(set) var viewState = ViewState.Idle {
        didSet { onViewStateChanged() }
    }
    
    /*
      Represents the dialog state
     */
    private(set) var dialogState = DialogState.Dismissed {
        didSet {
            switch self.dialogState {
            case .Show(title: _, message: _, button: _):
                onViewStateChanged()
                break
            default:
                break
            }
        }
    }
    
    /*
      Current title of the quiz
    */
    private(set) var quizTitleText = "" {
        didSet { onViewStateChanged() }
    }
    
    /*
      Current value of the guessTextField
    */
    private(set) var guessTextFieldText = "" {
        didSet { onViewStateChanged() }
    }
    
    /*
     Current value for the guessTextField.isEnabled
     */
    private(set) var guessTextFieldEnabled = false {
        didSet { onViewStateChanged() }
    }
    
    /*
     Current value of the action button title
     */
    private(set) var actionButtonTitle:String = "Start" {
        didSet { onViewStateChanged() }
    }
    
    /*
     Current value of the guess textfield
     */
    private(set) var guessesCounterText = "00/50" {
        didSet { onViewStateChanged() }
    }
    
    /*
     Current value of the remaining time label
     */
    private(set) var remainingTimeLabelText = "05:00" {
        didSet { onViewStateChanged() }
    }
    
    /*
     Represents an action to be performed in the UITableView
    */
    private(set) var tableViewAction:UITableViewAction = .None {
        didSet {
            if self.tableViewAction != .None {
                onViewStateChanged()
            }
        }
    }
    
    /*
     Current quiz correct guesses
    */
    var correctGuesses: [String] {
        return self.quizManager?.correctGuesses ?? []
    }
    
    /*
     The observer of this ViewModel
    */
    var viewStateObserver:QuizViewModelStateObserver? = nil
    
    /*
        Called once the view is loaded
    */
    func onViewLoaded() {
        self.viewState = .Loading
        QuizAPIRepo().getJavaKeywordsQuiz(callback: { result in
            switch(result) {
            case .success(let quizInfo):
                self.quizManager = QuizManager(quizInfo: quizInfo)
                break
            case .failure(_):
                self.viewState = .Error
                break
            }
        })
    }
    
    /*
        Performs a guess in the Quiz
    */
    func performGuess(guess:String) {
        if let correct = self.quizManager?.guess(guess), correct {
            self.guessTextFieldText = ""
        } else {
            self.guessTextFieldText = guess
        }
    }
    
    /*
        Performs the action of "Action" button (start|reset)
    */
    func onActionButtonPressed() {
        if let quizManager = self.quizManager {
            switch(quizManager.state) {
            case .Ready:
                quizManager.start()
                break
            default:
                quizManager.reset()
                break
            }
        }
    }
    
    /*
        Notifies the ViewModel that the latest TableViewAction was consumed
     */
    func consumeTableViewAction() {
        self.tableViewAction = .None
    }
    
    /*
      Notifies the ViewModel that the dialog has been dismissed
    */
    func onDialogDismissed() {
        self.dialogState = .Dismissed
        self.quizManager?.reset()
    }
    
    /*
     Called when app comes back to foreground
    */
    func resume() {
        if let quizManager = self.quizManager, quizManager.state == .Started {
            quizManager.reset()
            self.dialogState = DialogState.Restart()
        }
    }
    
    /*
        Called everytime the view state has changed
    */
    private func onViewStateChanged() {
        viewStateObserver?()
    }
    
    // MARK: QuizManagerObserver
    
    func onQuizTimeUpdate(remainingTimeInSeconds: Int) {
        let minutes = remainingTimeInSeconds / 60
        let seconds = remainingTimeInSeconds - (minutes * 60)
        
        self.remainingTimeLabelText = String(format:kTimerFormat, minutes, seconds)
    }
    
    func onQuizCorrectGuessesCountChanged(currentCount: Int, total: Int) {
        self.guessesCounterText = String(format:kGuessesCounterFormat, currentCount, total)
        if currentCount == 0 {
            self.tableViewAction = .ReloadData
        } else {
            self.tableViewAction = .AnimateInsertion
        }
    }
    
    func onQuizStateChanged(state: QuizManager.State) {
        var buttonTitle = "Reset"
        var guessTextFieldEnabled = false
        var dialogState = DialogState.Dismissed
        switch state {
        case .Ready:
            buttonTitle = "Start"
            break
        case .Finished:
            if let quizManager = self.quizManager {
                if quizManager.didWin {
                    dialogState = DialogState.Victory()
                } else {
                    dialogState = DialogState.Defeated(count: quizManager.correctGuesses.count, total: quizManager.quizInfo.answers.count)
                }
            }
            break
        case .Started:
            guessTextFieldEnabled = true
            break
        }
        
        self.guessTextFieldEnabled = guessTextFieldEnabled
        self.actionButtonTitle = buttonTitle
        self.dialogState = dialogState
    }
}
