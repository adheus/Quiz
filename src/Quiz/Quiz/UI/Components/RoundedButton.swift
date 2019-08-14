//
//  RoundedButton.swift
//  Quiz
//
//  Created by Adheús Rangel on 12/08/19.
//  Copyright © 2019 Adheus Rangel. All rights reserved.
//

import Foundation
import UIKit

class RoundedButton : UIButton {
    private let kDefaultCornerRadius:CGFloat = 8
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupView()
    }
    
    private func setupView() {
        self.layer.cornerRadius = kDefaultCornerRadius
    }
}
