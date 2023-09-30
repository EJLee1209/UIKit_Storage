//
//  CompositionalViewController.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/09/30.
//

import UIKit

class CompositionalViewController: UIViewController {
    
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
        MySection.third((1...20).compactMap { _ in URL(string: "https://random.imagecdn.app/\(size)/\(size)") }),
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
        
    }
    
    private func layout() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, env -> NSCollectionLayoutSection? in
            switch self.sectionItems[section] {
            case .first:
                return self.makeFirstSectionLayout()
            case .second:
                return self.makeSecondSectionLayout()
            case .third:
                return self.makeThridSectionLayout()
            default:
                return nil
            }
        }
    }
    
    private func makeFirstSectionLayout() -> NSCollectionLayoutSection? {
        /// item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(80),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        /// group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(90),
            heightDimension: .estimated(80))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        /// Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous // 수평 스크롤
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 10,
            bottom: 12,
            trailing: 10)
        
        /// header
        let header = makeHeaderView()
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func makeSecondSectionLayout() -> NSCollectionLayoutSection? {
        // item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(
            top: 0,
            leading: 10,
            bottom: 0,
            trailing: 10)
                
        // group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 10,
            bottom: 12,
            trailing: 10)
        
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
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 10,
            trailing: 0)
            
        // group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.5))
            
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 10,
            bottom: 12,
            trailing: 10)
        
        /// header
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
        default:
            return UICollectionViewCell()
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
            case .first(_):
                headerView.bind(text: "First Section")
            case .second(_):
                headerView.bind(text: "Second Section")
            case .third(_):
                headerView.bind(text: "Third Section")
            default:
                return UICollectionReusableView()
            }
            
            return headerView
        
        default:
            return UICollectionReusableView()
        }
    }
    
}
