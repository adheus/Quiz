//
//  QuizAPIRepo.swift
//  Quiz
//
//  Created by Adheús Rangel on 13/08/19.
//  Copyright © 2019 Adheus Rangel. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/*
  This class represents any result from calls to the QuizAPIRepo
 */
enum QuizAPIResult<T: JSONSerializable> {
    case success(value:T)
    case failure(error:Error)
}

/*
  Quiz API repository communication class
 */
class QuizAPIRepo {
    let kApiServer = URL(string: "https://codechallenge.arctouch.com/quiz")! // Only force unwrapping here because this is a constant [AR]
    
    // GET(java-keywords)
    let javaKeywordsQuizEndpoint = "java-keywords"
    func getJavaKeywordsQuiz(callback: @escaping (_ result:QuizAPIResult<QuizInfo>) -> Void) {
        Alamofire.request(kApiServer.appendingPathComponent(javaKeywordsQuizEndpoint), method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            switch(response.result) {
            case .success(let value):
                do {
                    let quizInfo = try QuizInfo(json: JSON(value))
                    callback(QuizAPIResult.success(value: quizInfo))
                } catch let error {
                    callback(QuizAPIResult.failure(error: error))
                }
                break
                
            case .failure(let error):
                callback(QuizAPIResult.failure(error: error))
                break
            }
        }
    }
}
