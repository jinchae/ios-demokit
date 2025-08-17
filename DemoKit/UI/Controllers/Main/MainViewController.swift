//
//  ViewController.swift
//  tovao
//
//  Created by AbleCnC on 2021/04/01.
//

import UIKit

class MainViewController: BaseViewController {
    static let headerKind = UICollectionView.elementKindSectionHeader
    static let footerKind = UICollectionView.elementKindSectionFooter
    //-------------------------------------------------------------------------------------------
    // MARK: - IBOutlet
    // MARK: * Storyboard 와 Controller 와 Component 연결
    //-------------------------------------------------------------------------------------------
    @IBOutlet weak var collectionView: UICollectionView!
    //-------------------------------------------------------------------------------------------
    // MARK: - Local Variable
    // MARK: * 변수선언
    //-------------------------------------------------------------------------------------------
    var itemSize:CGSize?
    let refresh = UIRefreshControl()
    var totalCount:Int = 0
    
    var dataList:[Product] = []
    var bannerTimer: Timer?
    var currentBannerIndex = 0
    //-------------------------------------------------------------------------------------------
    // MARK: - initView
    // MARK: * 초기뷰 세팅
    //-------------------------------------------------------------------------------------------
    enum Section: Int, Hashable, CaseIterable, CustomStringConvertible {
        case Banner,TimeSale, Popular, Recommend
        
        var description: String {
            switch self {
            case .Banner: return "배너"
            case .TimeSale: return "타임세일"
            case .Popular: return "지금 바로 확인해보세요!\n요즘 인기 많은 첫구매 상품이에요"
            case .Recommend: return "이런상품은 어떠세요?"
            }
        }
    }
    
    func initCollectionView(){
        self.collectionView.accessibilityIdentifier = "product_list"
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.collectionViewLayout = self.createLayout()
        
        //Header
        self.collectionView.registerReusableView(type: HeaderReusableView.self)
        //Banner
        self.collectionView.registerCell(type: BannerCell.self)
        //Footer
        self.collectionView.registerReusableView(type: BannerFooterReusableView.self, kind: MainViewController.footerKind)
        //Item
        self.collectionView.registerCell(type: ProductCell.self)
        
        self.refresh.addTarget(self, action: #selector(self.listUpdate), for: .valueChanged)
        self.collectionView.refreshControl = self.refresh
    }
    
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider: (Int, NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? = { sectionIndex, env in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: MainViewController.headerKind,
                alignment: .top
            )

            switch sectionKind {
            case .Banner:
                // 아이템/그룹: 1:1 정사각
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .fractionalWidth(1.0))
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .fractionalWidth(1.0)),
                    subitem: item, count: 1
                )
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = .zero

                // Footer 추가 (섹션 하단)
                let footerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(28) // 라벨 높이 + 여백
                )
                let footer = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: footerSize,
                    elementKind: MainViewController.footerKind,
                    alignment: .bottom
                )
                section.boundarySupplementaryItems = [footer]

                // 배너의 가로 스크롤 오프셋으로 현재 페이지 추적
                section.visibleItemsInvalidationHandler = { [weak self] _, offset, env in
                    guard let self else { return }
                    let pageWidth = env.container.effectiveContentSize.width
                    guard pageWidth > 0 else { return }
                    let page = Int(round(offset.x / pageWidth))
                    if page != self.currentBannerIndex {
                        self.currentBannerIndex = max(0, min(page, 10 - 1))
                        self.updateBannerFooter()
                    }
                }
                return section
            case .TimeSale:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(190),
                                                      heightDimension: .estimated(240))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)

                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(333),
                                                       heightDimension: .estimated(280))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
                section.boundarySupplementaryItems = [header]
                return section

            case .Popular:
                // 세로 스크롤 2열 그리드
                let gap: CGFloat = 10
                let item = NSCollectionLayoutItem(layoutSize:
                    .init(widthDimension: .fractionalWidth(0.5),
                          heightDimension: .estimated(260))
                )
                item.contentInsets = .init(top: 0, leading: 0, bottom: gap, trailing: gap)

                let group = NSCollectionLayoutGroup.horizontal(layoutSize:
                    .init(widthDimension: .fractionalWidth(1.0),
                          heightDimension: .estimated(260)),
                    subitem: item, count: 2
                )
                group.interItemSpacing = .fixed(gap)

                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = gap
                section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
                section.boundarySupplementaryItems = [header]
                return section
            case .Recommend:
                // 세로 스크롤, 1열(한 줄에 하나)
                let gap: CGFloat = 10

                // 아이템: 가로 꽉 채우고, 높이는 셀 오토레이아웃에 맞춰 추정
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .estimated(260))
                )
                // 한 줄이라 trailing gap 넣을 필요 없음
                item.contentInsets = .zero

                // 그룹: 한 줄에 아이템 1개
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .estimated(260)),
                    subitem: item,
                    count: 1
                )

                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = gap              // 줄 간 간격
                section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
                section.boundarySupplementaryItems = [header]
                return section
            }
        }

        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Override
    // MARK: * LifeCycle 초기화
    //-------------------------------------------------------------------------------------------
    override func initView() {
        super.initView()
        self.initCollectionView()
        self.listUpdate()
    }
 
    //-------------------------------------------------------------------------------------------
    // MARK: - Local Functions
    //-------------------------------------------------------------------------------------------
    func requestList(){
        do {
            self.dataList = try ProductLoader.loadFromBundle(fileName: "products")
        } catch {
            print("error load data")
        }
        self.refresh.endRefreshing()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startBannerAutoScroll()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopBannerAutoScroll()
    }

    private func startBannerAutoScroll() {
        stopBannerAutoScroll()
        self.bannerTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.advanceBanner()
        }
        RunLoop.main.add(bannerTimer!, forMode: .common) // 스크롤 중에도 동작
    }
    private func stopBannerAutoScroll() {
        bannerTimer?.invalidate()
        bannerTimer = nil
    }
    
    private func updateBannerFooter() {
        let kind = UICollectionView.elementKindSectionFooter
        // 지금 보이는 푸터만 바로 업데이트 (리로드 없이 부드럽게)
        self.collectionView.visibleSupplementaryViews(ofKind: kind).forEach { view in
            if let footer = view as? BannerFooterReusableView {
                footer.setEntity(self.currentBannerIndex)
            }
        }
    }
    
    private func advanceBanner() {
        let sec = Section.Banner.rawValue
        let total = 10
        guard total > 1 else { return }

        // 현재 페이지 기준으로 다음 계산
        let next = (self.currentBannerIndex + 1) % total
        let indexPath = IndexPath(item: next, section: sec)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        // 스크롤 애니메이션이 끝나면 handler에서 footer 업데이트가 자동으로 들어옴
    }
    //-------------------------------------------------------------------------------------------
    // MARK: - API Request
    //-------------------------------------------------------------------------------------------
    
    //-------------------------------------------------------------------------------------------
    // MARK: - IBActions & Gesture Actions
    //-------------------------------------------------------------------------------------------
    @objc func listUpdate(){
        self.requestList()
    }
}

//-------------------------------------------------------------------------------------------
// MARK: - Override Extensions
//-------------------------------------------------------------------------------------------
extension MainViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.stopBannerAutoScroll()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.startBannerAutoScroll()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
//      
//            if maximumOffset - currentOffset <= 10.0 {
//                if self.isLoadingList && self.request.total_cnt < self.row_count{
//                    self.isLoadingList = false
//                    self.requestList()
//                }
//            }
        }
    }
}
extension MainViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
   
    //headerCell
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionKind = Section(rawValue: indexPath.section) else { return UICollectionReusableView() }
            //setUp each sections
        switch sectionKind {
        case .Banner:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: MainViewController.footerKind, withReuseIdentifier: BannerFooterReusableView.identifier, for: indexPath) as! BannerFooterReusableView
            footerView.setEntity(self.currentBannerIndex)
            return footerView
        case .TimeSale, .Popular, .Recommend:
            let headerview = collectionView.dequeueReusableSupplementaryView(ofKind: MainViewController.headerKind, withReuseIdentifier: HeaderReusableView.identifier, for: indexPath) as! HeaderReusableView
            headerview.titleLabel.text = "\(sectionKind)"
            return headerview
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionKind = Section(rawValue: section) else { return 0 }
            //setUp each sections
        switch sectionKind {
        case .Banner:
            return 10
        case .TimeSale:
            return 10
        case .Popular:
            return 6
        case .Recommend:
            return self.dataList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unknown section") }
        switch section {
        case .Banner:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier, for: indexPath) as? BannerCell {
                if let item = self.dataList[indexPath.row] as? Product{
                    cell.thumbNail.setImage(item.image)
                }
                return cell
            }
        case .TimeSale:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell {
                if let item = self.dataList[indexPath.row] as? Product{
                    cell.setEntity(item)
                }
                return cell
            }
        case .Popular:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell {
                if let item = self.dataList[indexPath.row] as? Product{
                    cell.setEntity(item)
                }
                return cell
            }
        case .Recommend:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell {
                if let item = self.dataList[indexPath.row] as? Product{
                    cell.setEntity(item, .singleLarge)
                }
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = self.dataList[indexPath.row] as? Product{
            let link = item.link
            let destination = WebViewController.instantiate(storyboard: "WebView")
            destination.baseUrl = link
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }
}
