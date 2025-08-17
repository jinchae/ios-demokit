//
//  ProductCell.swift
//  DemoKit
//
//  Created by 정진채 on 8/17/25.
//

import UIKit

class ProductCell:UICollectionViewCell{
    
    enum DisplayMode {
        case gridSmall, singleLarge
    }
    
    @IBOutlet weak var thumbHeightConstraint: NSLayoutConstraint?
    @IBOutlet weak var thumbContainer: UIView!
    
    @IBOutlet weak var thumbNail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var benefitCollectionView: UICollectionView!
    
    var tagList:[String] = []
    var benefitList:[String] = []
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.thumbNail.setCornerRadius(radius: 4)
        // 멀티라인 설정
        self.titleLabel.numberOfLines = 3
        self.priceLabel.numberOfLines  = 2

        // 줄바꿈 방식
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.priceLabel.lineBreakMode = .byWordWrapping

        // 줄바꿈 허용하고 잘리지 않게
        self.titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        self.priceLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        self.initTagCollectionView()
        self.initBenefitCollectionView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbNail.image = nil
        self.thumbHeightConstraint?.constant = 121              // 기본값 리셋 (이전 상태 잔상 방지)
    }
    
    // Auto Layout 기반 셀프 사이징
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(
            CGSize(width: layoutAttributes.size.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        layoutAttributes.size = size
        return layoutAttributes
    }
    
    func initTagCollectionView(){
        self.tagCollectionView.registerCell(type: TagCell.self)
        
        let layout:UICollectionViewFlowLayout = self.tagCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = .zero
        
        self.tagCollectionView.backgroundColor = .white
        self.tagCollectionView.delegate = self
        self.tagCollectionView.dataSource = self
        
        self.tagCollectionView.reloadData()
    }
    
    func initBenefitCollectionView(){
        self.benefitCollectionView.registerCell(type: BenefitCell.self)
        
        let layout:UICollectionViewFlowLayout = self.benefitCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = .zero
        
        self.benefitCollectionView.backgroundColor = .white
        self.benefitCollectionView.delegate = self
        self.benefitCollectionView.dataSource = self
        
        self.benefitCollectionView.reloadData()
    }
    
    func setEntity(_ item:Product,_ display: DisplayMode = .gridSmall){
        self.thumbNail.contentMode = .scaleAspectFill
        self.thumbNail.clipsToBounds = true

        switch display {
        case .singleLarge:
            self.thumbHeightConstraint?.constant = 242
        case .gridSmall:
            self.thumbHeightConstraint?.constant = 121
        }

        setNeedsLayout()
        layoutIfNeeded()
        
        self.thumbNail.setImage(item.image)
        self.titleLabel.attributedText = self.makeBrandName(item.brand, item.name)
        self.priceLabel.attributedText = self.makePrice(item.price, item.discountPrice, item.discountRate)
        
        self.tagList = item.tags
        self.benefitList = item.benefits
        
        self.tagCollectionView.reloadData()
        self.benefitCollectionView.reloadData()
    }
    
    func makeBrandName(_ brand:String,_ name:String) -> NSMutableAttributedString{
        let color = UIColor(named: "333333")
        let regular = Tools.shared.getFont(.regular, 14)
        let bold = Tools.shared.getFont(.bold, 14)

        // name이 brand로 시작하면 그대로 사용, 아니면 "brand name" 형태로 합침
        let combined: String
        if name.hasPrefix(brand) {
            combined = name
        } else {
            combined = brand.isEmpty ? name : "\(brand) \(name)"
        }

        let attr = NSMutableAttributedString(
            string: combined,
            attributes: [
                .font: regular,
                .foregroundColor: color as Any
            ]
        )

            // 가장 앞쪽 brand 부분만 Bold 처리
        if combined.hasPrefix(brand), !brand.isEmpty {
            let range = (combined as NSString).range(of: brand)
            attr.addAttributes([.font: bold], range: range)
        }

        return attr
    }
    
    func makePrice(_ price:Int,_ discountPrice:Int,_ discountRate:Int) -> NSMutableAttributedString{
        let color333 = UIColor(named: "333333")
        let color666 = UIColor(named: "666666")
        let color999 = UIColor(named: "999999")
        let red = UIColor.systemRed
        
        let bold16 = Tools.shared.getFont(.bold, 16)
        let regular13 = Tools.shared.getFont(.regular, 13)
        let regular10 = Tools.shared.getFont(.regular, 10)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.lineSpacing = 2

        if discountRate > 0 {
            let result = NSMutableAttributedString()

            // 1줄: 원가(취소선)
            let originLine = "\(price.decimalString)원"
            result.append(NSAttributedString(
                string: originLine,
                attributes: [
                    .font: regular10,
                    .foregroundColor: color999,
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .strikethroughColor: color999,
                    .paragraphStyle: paragraph
                ]
            ))
            result.append(NSAttributedString(string: "\n"))

            // 2줄: 할인율 + 판매가 + 원
            // 할인율 "25%"
            result.append(NSAttributedString(
                string: "\(discountRate)%",
                attributes: [
                    .font: bold16,
                    .foregroundColor: red,
                    .paragraphStyle: paragraph
                ]
            ))

            // 공백
            result.append(NSAttributedString(string: " "))

            // 판매가 숫자
            result.append(NSAttributedString(
                string: discountPrice.decimalString,
                attributes: [
                    .font: bold16,
                    .foregroundColor: color333,
                    .paragraphStyle: paragraph
                ]
            ))

            // "원" (레이블 13, #666)
            result.append(NSAttributedString(
                string: "원",
                attributes: [
                    .font: regular13,
                    .foregroundColor: color666,
                    .paragraphStyle: paragraph
                ]
            ))
            return result
        } else {
            // 단일 라인: 금액(볼드 16, #333) + "원"(레귤러 13, #666)
            let result = NSMutableAttributedString(
                string: price.decimalString,
                attributes: [
                    .font: bold16,
                    .foregroundColor: color333,
                    .paragraphStyle: paragraph
                ]
            )
            result.append(NSAttributedString(
                string: "원",
                attributes: [
                    .font: regular13,
                    .foregroundColor: color666,
                    .paragraphStyle: paragraph
                ]
            ))
            return result
        }
    }
}

extension ProductCell:UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.tagCollectionView{
            let itemSize = CGSize(width: self.width(text: self.tagList[indexPath.row], font: Tools.shared.getFont(.regular,10), extra: 10), height: 15)
            return itemSize
        }else{
            let itemSize = CGSize(width: self.width(text: self.benefitList[indexPath.row], font: Tools.shared.getFont(.regular,10), extra: 15), height: 15)
            return itemSize
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.tagCollectionView{
            return self.tagList.count
        }else{
            return self.benefitList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.tagCollectionView{
            return 0
        }else{
            return 8
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.tagCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as! TagCell
            if indexPath.row == self.tagList.count - 1{
                cell.circleView.isHidden = true
            }else{
                cell.circleView.isHidden = false
            }
            cell.titleLabel.text = self.tagList[indexPath.row]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BenefitCell.identifier, for: indexPath) as! BenefitCell
            cell.titleLabel.text = self.benefitList[indexPath.row]
            return cell
        }
    }
}

extension ProductCell{
    func width(text: String, font: UIFont, extra: CGFloat = 0) -> CGFloat {
        guard !text.isEmpty else { return ceil(extra) }
        let size = (text as NSString).boundingRect(
            with: CGSize(width: .greatestFiniteMagnitude, height: font.lineHeight),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        ).size
        return ceil(size.width) + extra
    }
}
