//
//  BaseCustomView.swift
//  DemoKit
//
//  Created by 정진채 on 8/17/25.
//

import UIKit

class BaseCustomView: UIView {

    // MARK: - Vars
    
    var containerView: UIView!

    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInitialization()
    }
    
    func commonInitialization() {
        self.containerView = Bundle.main.loadNibNamed(self.className, owner: self, options: nil)?.first as? UIView
        self.containerView.frame = self.bounds
        self.containerView.backgroundColor = UIColor(named: "Translate")
        self.addSubview(self.containerView)
    }

}



