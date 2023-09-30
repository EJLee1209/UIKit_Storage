//
//  ManySectionViewController.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/09/30.
//

import UIKit

enum MySection {
    case first([String])
    case second([String])
}

final class ManySectionViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(BasicCell.self, forCellWithReuseIdentifier: "basicCell")
        cv.register(MyHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyHeaderView.identifier)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    private let cellSpace: CGFloat = 10
    private let numberOfColumn: CGFloat = 2
    
    private let sectionItems: [MySection] = [
        MySection.first((1...10).map { "First \($0)" }),
        MySection.second((1...10).map { "Second \($0)" })
    ]
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
    }
    
    //MARK: - Helpers
    private func layout() {
        navigationItem.title = CollectionViewSubject.manySection.rawValue
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - UICollectionViewDataSource
extension ManySectionViewController: UICollectionViewDataSource {
    
    /// Section 개수 정의
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
        }
    }
    
    /// Cell 꺼내기
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "basicCell", for: indexPath) as! BasicCell
        switch sectionItems[indexPath.section] {
        case .first(let sectionItem):
            cell.bind(text: sectionItem[indexPath.row])
        case .second(let sectionItem):
            cell.bind(text: sectionItem[indexPath.row])
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
            }
            
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ManySectionViewController: UICollectionViewDelegateFlowLayout {
    /// Section inset
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return .init(top: 10, left: cellSpace, bottom: 50, right: cellSpace)
    }
    
    /// Cell 크기
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let paddingSpace = cellSpace * (numberOfColumn + 1)
        let availableWidth = view.frame.width - paddingSpace
        let itemWidth = availableWidth / numberOfColumn
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    /// 행 간격
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
    
    /// 열 간격
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
    
    // header 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 30)
    }
}
