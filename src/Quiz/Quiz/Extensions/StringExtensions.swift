//
//  StringExtensions.swift
//  Quiz
//
//  Created by Adheús Rangel on 13/08/19.
//  Copyright © 2019 Adheus Rangel. All rights reserved.
//

import Foundation
extension StringProtocol {
    /*
      Capitalizes first letter of the string
    */
    var firstLetterCapitalized: String {
        return prefix(1).capitalized + dropFirst()
    }
}
