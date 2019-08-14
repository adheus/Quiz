//
//  ErrorView.swift
//  Quiz
//
//  Created by Adheús Rangel on 14/08/19.
//  Copyright © 2019 Adheus Rangel. All rights reserved.
//

import Foundation
import UIKit

class ErrorView : UIView {
    var delegate: ErrorViewDelegate?
    
    @IBOutlet var contentView:UIView!
    @IBOutlet var errorMessageLabel:UILabel!
    @IBOutlet var retryButton:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupView()
    }
    private func setupView() {
        Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil)
        self.addSubview(self.contentView)
    }
    
    @IBAction func onRetryPressed() {
        self.delegate?.retry()
    }
}

protocol ErrorViewDelegate {
    func retry()
}
