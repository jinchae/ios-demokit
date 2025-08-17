//
//  BannerFooterReusableView.swift
//  DemoKit
//
//  Created by 정진채 on 8/17/25.
//

import UIKit

class BannerFooterReusableView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setEntity(_ index:Int) {
        self.titleLabel.attributedText = self.makeCounterAttr(current: index)
    }
    
    func makeCounterAttr(current index: Int) -> NSAttributedString {
        let color333 = UIColor(named: "333333")
        let color666 = UIColor(named: "666666")

        let bold   = Tools.shared.getFont(.bold, 14)
        let regular = Tools.shared.getFont(.regular, 14)

        let attr = NSMutableAttributedString(
            string: "\(index + 1)",
            attributes: [.font: bold, .foregroundColor: color333]
        )
        attr.append(NSAttributedString(string: " | ",
            attributes: [.font: regular, .foregroundColor: color666]))
        attr.append(NSAttributedString(string: "10",
            attributes: [.font: regular, .foregroundColor: color666]))
        return attr
    }
}

