//
//  QuizInfo.swift
//  Quiz
//
//  Created by Adheús Rangel on 12/08/19.
//  Copyright © 2019 Adheus Rangel. All rights reserved.
//

import Foundation


class QuizInfo {
    let durationInMinutes = 5
    
    
    let question: String
    let answers:[String]
    
    init() {
        self.question = "What are all the java keywords?"
        self.answers = [ "public", "final", "class", "synchronized", "int", "float"]
    }
}
