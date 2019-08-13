//
//  RoundedTextField.swift
//  Quiz
//
//  Created by Adheús Rangel on 12/08/19.
//  Copyright © 2019 Adheus Rangel. All rights reserved.
//

import Foundation
import UIKit

class RoundedTextField : UITextField {
    private let kDefaultBackgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
    private let kDefaultCornerRadius:CGFloat = 5
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    private func setupView() {
        self.backgroundColor = kDefaultBackgroundColor
        self.layer.cornerRadius = kDefaultCornerRadius
    }
}
