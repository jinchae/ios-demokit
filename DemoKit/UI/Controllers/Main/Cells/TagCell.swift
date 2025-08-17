//
//  TagCell.swift
//  DemoKit
//
//  Created by 정진채 on 8/17/25.
//


import UIKit

class TagCell:UICollectionViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.circleView.setCornerRadius(radius: 2)
        self.titleLabel.font = Tools.shared.getFont(.regular,10)
        self.titleLabel.textColor = UIColor(named: "666666")
    }
    
}
