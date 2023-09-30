//
//  HorizonViewController.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/09/30.
//

import UIKit

class HorizonViewController: UIViewController {
    
    //MARK: - Properties
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(BasicCell.self, forCellWithReuseIdentifier: "basicCell")
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private let cellSpace: CGFloat = 10
    
    private var size: Int {
        (100...800).randomElement()!
    }
    
    lazy var dataSource = (1...30)
        .compactMap { _ in URL(string: "https://random.imagecdn.app/\(size)/\(size)") }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
    }
    
    //MARK: - Helpers
    private func layout() {
        navigationItem.title = CollectionViewSubject.horizontal.rawValue
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(150)
        }
    }
    
    
}

//MARK: - UICollectionViewDataSource
extension HorizonViewController: UICollectionViewDataSource {
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
extension HorizonViewController: UICollectionViewDelegateFlowLayout {
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
        return CGSize(width: 150, height: collectionView.frame.height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return cellSpace
    }
}
