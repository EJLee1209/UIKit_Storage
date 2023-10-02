//
//  CompositionalViewController.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/09/30.
//

import UIKit

final class CompositionalViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        cv.dataSource = self
        cv.register(BasicCell.self, forCellWithReuseIdentifier: BasicCell.identifier)
        cv.register(MyHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyHeaderView.identifier)
        return cv
    }()
    
    private var size: Int {
        (300...500).randomElement()!
    }
    
    private lazy var sectionItems: [MySection] = [
        MySection.first((1...30).compactMap { _ in URL(string: "https://random.imagecdn.app/\(size)/\(size)") }),
        MySection.second((1...6).compactMap { _ in URL(string: "https://random.imagecdn.app/\(size)/\(size)") }),
        MySection.third((1...3).compactMap { _ in URL(string: "https://random.imagecdn.app/\(size)/\(size)") }),
        MySection.fourth((1...25).compactMap { _ in URL(string: "https://random.imagecdn.app/\(size)/\(size)") }),
        MySection.fifth((1...12).compactMap { _ in URL(string: "https://random.imagecdn.app/\(size)/\(size)") }),
    ]
    private let layoutInset: CGFloat = 10
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
        
    }
    
    //MARK: - Helpers
    
    private func layout() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.collectionView.layoutIfNeeded()
        
    }
    
}



//MARK: - Compositional Layout
extension CompositionalViewController {
    private func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, env -> NSCollectionLayoutSection? in
            switch self.sectionItems[section] {
            case .first:
                return self.makeFirstSectionLayout()
            case .second:
                return self.makeSecondSectionLayout()
            case .third:
                return self.makeThridSectionLayout()
            case .fourth:
                return self.makeFourthSectionLayout()
            case .fifth:
                return self.makeFifthSectionLayout()
            }
        }
    }
    
    private func makeFirstSectionLayout() -> NSCollectionLayoutSection? {
        let fraction: CGFloat = 1.0 / 3.0
        
        /// item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        /// group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(fraction),
            heightDimension: .fractionalWidth(fraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        /// Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous // 수평 스크롤
        
        
        section.visibleItemsInvalidationHandler = { (items, offset, env) in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - env.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.7
                let maxScale: CGFloat = 1.1
                let scale = max(maxScale - (distanceFromCenter / env.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        
        
        
        return section
    }
    
    private func makeSecondSectionLayout() -> NSCollectionLayoutSection? {
        // item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: layoutInset, leading: 0, bottom: layoutInset, trailing: layoutInset)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        /// header
        let header = makeHeaderView()
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func makeThridSectionLayout() -> NSCollectionLayoutSection? {
        // item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
        // group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: layoutInset, leading: layoutInset, bottom: 0, trailing: layoutInset)
        // section
        let section = NSCollectionLayoutSection(group: group)
        
        /// header
        let header = makeHeaderView()
        section.boundarySupplementaryItems = [header]
        
            
        return section
    }
    
    private func makeFourthSectionLayout() -> NSCollectionLayoutSection? {
        let itemInset = 2.5
        /// Large Item
        let largeItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1))
        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
        largeItem.contentInsets = .init(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
        
        /// Small Item
        let smallItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.5))
        let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
        smallItem.contentInsets = .init(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
        
        /// Inner Group
        let innerGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.25),
            heightDimension: .fractionalHeight(1))
        let innerGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: innerGroupSize,
            subitems: [smallItem])
        
        /// Outer Group
        let outerGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(0.5))
        let outerGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: outerGroupSize,
            subitems: [largeItem, innerGroup, innerGroup])
        outerGroup.contentInsets = .init(top: layoutInset, leading: layoutInset, bottom: 0, trailing: layoutInset)
        
        /// Section
        let section = NSCollectionLayoutSection(group: outerGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        
        /// Header
        let header = makeHeaderView()
        section.boundarySupplementaryItems = [header]
        
        
        return section
    }
    
    private func makeFifthSectionLayout() -> NSCollectionLayoutSection? {
        let innerInset: CGFloat = 1.5
        /// Large Item
        let largeItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.6))
        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
        largeItem.contentInsets = .init(top: 0, leading: 0, bottom: innerInset, trailing: 0)
        
        /// inner Small Item
        let innerSmallItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.4),
            heightDimension: .fractionalHeight(1))
        let innerSmallItem = NSCollectionLayoutItem(layoutSize: innerSmallItemSize)
        innerSmallItem.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: innerInset)
        
        /// inner Large Item
        let innerLargeItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.6),
            heightDimension: .fractionalHeight(1))
        let innerLargeItem = NSCollectionLayoutItem(layoutSize: innerLargeItemSize)
        
        /// inner Group
        let innerGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.4))
        
        let innerGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: innerGroupSize,
            subitems: [innerSmallItem, innerLargeItem])
        
        /// Outer Group
        let outerGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.8))
        let outerGroup = NSCollectionLayoutGroup.vertical(layoutSize: outerGroupSize, subitems: [largeItem, innerGroup])
        outerGroup.contentInsets = .init(top: 0, leading: 0, bottom: innerInset, trailing: 0)
        
        /// Section
        let section = NSCollectionLayoutSection(group: outerGroup)
        section.contentInsets = .init(top: layoutInset, leading: 0, bottom: 0, trailing: 0)
        
        /// Header
        let header = makeHeaderView()
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func makeHeaderView() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
            
        return header
    }
    
    
}

//MARK: - UICollectionViewDataSource
extension CompositionalViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionItems.count
    }
    /// item 개수 정의
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sectionItems[section] {
        case .first(let sectionItem):
            return sectionItem.count
        case .second(let sectionItem):
            return sectionItem.count
        case .third(let sectionItem):
            return sectionItem.count
        case .fourth(let sectionItem):
            return sectionItem.count
        case .fifth(let sectionItem):
            return sectionItem.count
        }
    }
    
    /// Cell 꺼내기
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicCell.identifier, for: indexPath) as! BasicCell
        switch sectionItems[indexPath.section] {
        case .first(let sectionItem):
            cell.bind(imageUrl: sectionItem[indexPath.row])
        case .second(let sectionItem):
            cell.bind(imageUrl: sectionItem[indexPath.row])
        case .third(let sectionItem):
            cell.bind(imageUrl: sectionItem[indexPath.row])
        case .fourth(let sectionItem):
            cell.bind(imageUrl: sectionItem[indexPath.row])
        case .fifth(let sectionItem):
            cell.bind(imageUrl: sectionItem[indexPath.row])
        }
        
        return cell
    }
    /// SupplementaryView(Header, Footer) 꺼내기
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MyHeaderView.identifier,
                for: indexPath
            ) as! MyHeaderView
            
            switch sectionItems[indexPath.section] {
            case .second:
                headerView.bind(text: "Second Section")
            case .third:
                headerView.bind(text: "Third Section")
            case .fourth:
                headerView.bind(text: "Fourth Section")
            case .fifth:
                headerView.bind(text: "Fifth Section")
            default:
                return UICollectionReusableView()
            }
            
            return headerView
        
        default:
            return UICollectionReusableView()
        }
    }
    
}
