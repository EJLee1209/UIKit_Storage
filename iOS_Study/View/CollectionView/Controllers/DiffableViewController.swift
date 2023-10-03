//
//  DiffableViewController.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/10/02.
//

import UIKit

class DiffableViewController: UIViewController {
    //MARK: - Properties
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        cv.register(MyHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyHeaderView.identifier)
        cv.delegate = self
        return cv
    }()
    private let cellSpace: CGFloat = 10
    private let numberOfColumn: CGFloat = 2
    var dataSource: MyDataSource?
    
    private var size: Int {
        (100...800).randomElement()!
    }
    
    private lazy var sectionItems: [DiffableSection: [DiffableSectionItem]] = [
        DiffableSection.first: (1...30)
            .compactMap { _ in URL(string: "https://random.imagecdn.app/\(size)/\(size)") }
            .map { DiffableSectionItem.firstItem(.init(url: $0)) },
        
        DiffableSection.second: (1...10)
            .compactMap { _ in URL(string: "https://random.imagecdn.app/\(size)/\(size)") }
            .map { DiffableSectionItem.firstItem(.init(url: $0)) },
    ]
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        setupDataSource()
        updateSnapshot(items: sectionItems)
    }
    
    //MARK: - Helpers
    private func layout() {
        navigationItem.title = CollectionViewSubject.diffableDataSource.rawValue
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - DiffableDataSource
extension DiffableViewController {
    /// Diffable DataSource 정의
    /// 파라미터로 collectionView와 cellProvider 전달
    /// cellProvider를 통해 UI에 표시할 셀을 리턴
    private func setupDataSource() {
        dataSource = .init(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .firstItem(let item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
                cell.bind(imageUrl: item.url)
                return cell
            case .secondItem(let item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
                cell.bind(imageUrl: item.url)
                return cell
            }
        })
        
        dataSource?.supplementaryViewProvider = { (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            switch elementKind {
            case UICollectionView.elementKindSectionHeader:
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: MyHeaderView.identifier,
                    for: indexPath
                ) as! MyHeaderView
                
                switch DiffableSection.allCases[indexPath.section] {
                case .first:
                    header.bind(text: "First Section")
                case .second:
                    header.bind(text: "Second Section")
                }
                return header
            default:
                return nil
            }
        }
    }
    
    /// DiffableDataSource는 Snapshot을 사용해서 CollectionView 또는 TableView에 데이터를 제공
    /// 스냅샷을 사용해서 뷰에 표시되는 데이터의 초기 상태를 설정하고, 데이터의 변경 사항을 반영
    /// 스냅샷의 데이터는 표시하려는 Section과 Item으로 구성
    private func updateSnapshot(items: [DiffableSection: [DiffableSectionItem]]) {
        var snapshot = MySnapshot()
        snapshot.appendSections(DiffableSection.allCases)
        items.forEach { key, value in
            snapshot.appendItems(value, toSection: key)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
}

extension DiffableViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return .init(top: 0, left: cellSpace, bottom: 0, right: cellSpace)
    }
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
    
    // header 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 50)
    }
}
