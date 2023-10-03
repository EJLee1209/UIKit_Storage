//
//  ManySectionViewController.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/09/30.
//

import UIKit



final class ManySectionViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        cv.register(MyHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyHeaderView.identifier)
        cv.register(MyFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MyFooterView.identifier)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    private let cellSpace: CGFloat = 10
    private let numberOfColumn: CGFloat = 2
    
    private var size: Int {
        (100...800).randomElement()!
    }
    
    private lazy var sectionItems: [MySection] = [
        MySection.first((1...2).compactMap { _ in URL(string: "https://random.imagecdn.app/\(size)/\(size)") }),
        MySection.second((1...6).compactMap { _ in URL(string: "https://random.imagecdn.app/\(size)/\(size)") }),
        MySection.third((1...8).compactMap { _ in URL(string: "https://random.imagecdn.app/\(size)/\(size)") }),
        MySection.fourth((1...4).compactMap { _ in URL(string: "https://random.imagecdn.app/\(size)/\(size)") }),
        MySection.fifth((1...10).compactMap { _ in URL(string: "https://random.imagecdn.app/\(size)/\(size)") }),
    ]
    
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
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
            case .first(_):
                headerView.bind(text: "First Section")
            case .second(_):
                headerView.bind(text: "Second Section")
            case .third(_):
                headerView.bind(text: "Third Section")
            case .fourth(_):
                headerView.bind(text: "Fourth Section")
            case .fifth(_):
                headerView.bind(text: "Fifth Section")
            }
            
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MyFooterView.identifier,
                for: indexPath
            ) as! MyFooterView
            
            switch sectionItems[indexPath.section] {
            case .first(_):
                footerView.bind(text: "First Section's Footer View")
            case .second(_):
                footerView.bind(text: "Second Section's Footer View")
            case .third(_):
                footerView.bind(text: "Third Section's Footer View")
            case .fourth(_):
                footerView.bind(text: "Fourth Section's Footer View")
            case .fifth(_):
                footerView.bind(text: "Fifth Section's Footer View")
            }
            
            return footerView
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
        return .init(top: 10, left: cellSpace, bottom: 10, right: cellSpace)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 50)
    }
}
