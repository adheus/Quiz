//
//  ViewExtensions.swift
//  Quiz
//
//  Created by Adheús Rangel on 14/08/19.
//  Copyright © 2019 Adheus Rangel. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    
    func showAnimated() {
        self.animateHiddenStateChange(shouldHide: false)
    }
    
    func hideAnimated() {
        self.animateHiddenStateChange(shouldHide: true)
    }
    
    private func animateHiddenStateChange(shouldHide:Bool) {
        let hiddenAnimationTime:Double = 0.3
        if self.isHidden {
            self.alpha = 0
            self.isHidden = false
        }
        UIView.animate(withDuration: hiddenAnimationTime, animations: {
            self.alpha = shouldHide ? 0 : 1
        }, completion: { completed in
            self.isHidden = shouldHide
        })
    }
}
