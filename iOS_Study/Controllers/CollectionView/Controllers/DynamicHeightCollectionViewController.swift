//
//  DynamicHeightCollectionViewController.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/09/25.
//

import UIKit

class DynamicHeightCollectionViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        view.contentInsetAdjustmentBehavior = .always
        view.register(DynamicHeightCell.self, forCellWithReuseIdentifier: "cell")
        view.dataSource = self
        return view
    }()
    private static var width: Int {
        Int(UIScreen.main.bounds.width)
    }
    
    private static var height: Int {
        (100...800).randomElement()!
    }
    
    var dataSource = (1...10)
        .compactMap { _ in URL(string: "https://random.imagecdn.app/\(DynamicHeightCollectionViewController.width)/\(DynamicHeightCollectionViewController.height)") }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        
    }
    
    private func layout() {
        navigationItem.title = CollectionViewSubject.dynamicHeight.rawValue
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


extension DynamicHeightCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DynamicHeightCell
        cell.bind(imageURL: dataSource[indexPath.row])
        return cell
    }
}
