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
    private let kDefaultCornerRadius:CGFloat = 5
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    private func setupView() {
        self.layer.cornerRadius = kDefaultCornerRadius
    }
}
