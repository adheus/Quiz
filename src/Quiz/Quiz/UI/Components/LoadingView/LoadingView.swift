//
//  LoadingView.swift
//  Quiz
//
//  Created by Adheús Rangel on 14/08/19.
//  Copyright © 2019 Adheus Rangel. All rights reserved.
//

import Foundation
import UIKit

class LoadingView : UIView {
    private let kDefaultCornerRadius:CGFloat = 16
    private let kDefaultLabelText = "Loading..."
    
    @IBOutlet var contentView:UIView!
    @IBOutlet var loadingIndicator:UIActivityIndicatorView!
    @IBOutlet var label:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupView()
    }
    
    var isLoading:Bool = false {
        didSet {
            self.isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
        }
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)
        self.backgroundColor = UIColor.clear
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.layer.cornerRadius = kDefaultCornerRadius
        self.loadingIndicator.style = .whiteLarge
        self.label.text = kDefaultLabelText
    }
}
