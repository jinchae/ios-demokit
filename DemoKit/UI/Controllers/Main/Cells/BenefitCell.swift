//
//  BenefitCell.swift
//  DemoKit
//
//  Created by 정진채 on 8/17/25.
//


import UIKit

class BenefitCell:UICollectionViewCell{
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.baseView.setCornerRadius(radius: 8)
        self.titleLabel.font = Tools.shared.getFont(.regular, 10)
        
        self.baseView.layer.borderWidth = 1
        self.baseView.layer.borderColor = UIColor(named: "999999")?.cgColor
        self.titleLabel.textColor = UIColor(named: "666666")
    }
}
