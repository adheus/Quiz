//
//  QuizManager.swift
//  Quiz
//
//  Created by Adheús Rangel on 12/08/19.
//  Copyright © 2019 Adheus Rangel. All rights reserved.
//

import Foundation

class QuizManager {
    enum State {
        case Ready, Started, Finished
    }
    
    let quizInfo:QuizInfo
    
    var observer:QuizManagerObserver?
    
    private(set) var state: State = State.Ready {
        didSet { onQuizStateChanged() }
    }
    
    /*
      Checks if the quiz is in progress
     */
    var isInProgress:Bool {
        return state == State.Started
    }
    
    /*
      Checks if the player finished this quiz
     */
    var didWin:Bool {
        return self.correctGuesses.count == self.quizInfo.answers.count
    }
    
    /*
      Checks if the timer for this quiz has ran out
     */
    var timesUp:Bool {
        return self.remainingTimeInSeconds <= 0
    }
    
    var timer:Timer?
    private(set) var remainingTimeInSeconds:Int = 0 {
        didSet { self.observer?.onQuizTimeUpdate(remainingTimeInSeconds: self.remainingTimeInSeconds) }
    }

    var correctGuesses:[String] = []
    
    init(quizInfo:QuizInfo) {
        self.quizInfo = quizInfo
    }
    
    func start() {
        self.state = State.Started
    }
    
    func reset() {
        self.state = State.Ready
    }
    
    func guess(_ answer:String) -> Bool {
        if self.state == State.Started && self.quizInfo.answers.contains(answer) && !self.correctGuesses.contains(answer) {
            self.correctGuesses.insert(answer, at:0)
            self.observer?.onQuizCorrectGuessesCountChanged(currentCount:self.correctGuesses.count, total:self.quizInfo.answers.count)
            checkifQuizFinished()
            return true
        }
        return false
    }
    
    
    private func checkifQuizFinished() {
        // If all answers were guessed, the quiz has finished [AR]
        if self.didWin || self.timesUp {
            self.state = State.Finished
        }
    }
    
    private func onQuizStateChanged() {
        switch(self.state) {
        case .Ready:
            self.stopTimer()
            self.correctGuesses.removeAll()
            self.observer?.onQuizCorrectGuessesCountChanged(currentCount:self.correctGuesses.count, total:self.quizInfo.answers.count)
            self.remainingTimeInSeconds = self.quizInfo.durationInMinutes * 60
            break
        case .Started:
            self.startTimer()
            break
        case .Finished:
            self.stopTimer()
            break
        }
        self.observer?.onQuizStateChanged(state: self.state)
    }
    
    
    private func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: true, block: { [weak self] timer in
            if let self = self {
                self.remainingTimeInSeconds-=1
                print("Time update: \(self.remainingTimeInSeconds)")
            }
        })
    }
    
    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
}

protocol QuizManagerObserver {
    
    func onQuizTimeUpdate(remainingTimeInSeconds:Int)
    
    func onQuizCorrectGuessesCountChanged(currentCount: Int, total: Int)
    
    func onQuizStateChanged(state:QuizManager.State)
}

extension QuizManagerObserver {
    
    func onQuizTimeUpdate(remainingTimeInSeconds:Int) {
        // This is a empty implementation to allow this method to be optional
    }
    
    func onQuizCorrectGuessesCountChanged(currentCount:Int, total:Int) {
        // This is a empty implementation to allow this method to be optional
    }
    
    func onQuizStateChanged(state:QuizManager.State) {
        // This is a empty implementation to allow this method to be optional
    }
}
