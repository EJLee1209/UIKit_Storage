//
//  CollectionViewBasicViewController.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/09/30.
//

import UIKit

class CollectionViewBasicViewController: UIViewController {
    
    //MARK: - Properties
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(BasicCell.self, forCellWithReuseIdentifier: "basicCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    private let cellSpace: CGFloat = 10
    private let numberOfColumn: CGFloat = 2
    
    private var size: Int {
        (100...800).randomElement()!
    }
    
    private lazy var dataSource = (1...30)
        .compactMap { _ in URL(string: "https://random.imagecdn.app/\(size)/\(size)") }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
    }
    
    //MARK: - Helpers
    private func layout() {
        navigationItem.title = CollectionViewSubject.basic.rawValue
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - UICollectionViewDataSource
extension CollectionViewBasicViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "basicCell", for: indexPath) as! BasicCell
        cell.bind(imageUrl: dataSource[indexPath.row])
        return cell
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewBasicViewController: UICollectionViewDelegateFlowLayout {
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
}
