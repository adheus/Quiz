//
//  QuizInfo.swift
//  Quiz
//
//  Created by Adheús Rangel on 12/08/19.
//  Copyright © 2019 Adheus Rangel. All rights reserved.
//

import Foundation
import SwiftyJSON

class QuizInfo : JSONSerializable {
   
    let durationInMinutes = 5
    
    private(set) var question: String!
    private(set) var answers:[String]!
        
    required init(json: JSON) throws {
        self.question = try required(json["question"].string)
        self.answers = try required(json["answer"].array?.map { $0.stringValue })
    }
    
    init(question:String, answers:[String]) {
        self.question = question
        self.answers = answers
    }
    
    func toJSON() -> JSON {
        return JSON(dictionaryLiteral:
            ("question", self.question as String),
            ("answer", self.answers as [String])
        )
    }
}
