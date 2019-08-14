//
//  GuessTableViewCell.swift
//  Quiz
//
//  Created by Adheús Rangel on 13/08/19.
//  Copyright © 2019 Adheus Rangel. All rights reserved.
//

import Foundation
import UIKit

class GuessTableViewCell : UITableViewCell {
    @IBOutlet var label:UILabel!
    
    
    func setupFor(guess: String) {
        self.label.text = guess.firstLetterCapitalized
    }
}
