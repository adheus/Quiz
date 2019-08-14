//
//  JSONSerializable.swift
//  Quiz
//
//  Created by Adheús Rangel on 13/08/19.
//  Copyright © 2019 Adheus Rangel. All rights reserved.
//

import Foundation
import SwiftyJSON

class JSONSerializationError: Error {
    let message = "Invalid JSON for this object."
}

protocol JSONSerializable {
    init(json:JSON) throws
    
    func toJSON() -> JSON
}

extension JSONSerializable {
    /*
      Tries to unwrap the optional value as it is a required field, if not present, it throws a JSONSerializationError
      -parameter value Value to be unwrapped
    */
    func required<T>(_ value: T?) throws -> T {
        guard let value = value  else {
            throw JSONSerializationError()
        }
        return value
    }
}
