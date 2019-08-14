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
    private let kDefaultCornerRadius:CGFloat = 8
    private let kDefaultLateralTextMargins:CGFloat = 8
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = self.kDefaultBackgroundColor
        self.layer.cornerRadius = self.kDefaultCornerRadius
    }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(
            x: bounds.origin.x + kDefaultLateralTextMargins,
            y: bounds.origin.y,
            width: bounds.size.width - kDefaultLateralTextMargins * 2,
            height: bounds.size.height
        )
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
}
