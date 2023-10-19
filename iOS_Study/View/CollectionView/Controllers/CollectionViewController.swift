//
//  CollectionViewController.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/09/25.
//

import UIKit

class CollectionViewController: UIViewController {

    //MARK: - Properties
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        return tv
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        layout()
    }
    
    //MARK: - Helpers
    private func layout() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "CollectionView"
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
}


//MARK: - UITableViewDataSource
extension CollectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CollectionViewSubject.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = CollectionViewSubject.allCases[indexPath.row].rawValue
        return cell
    }
}

//MARK: - UITableViewDelegate
extension CollectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var toVC: UIViewController!
        
        switch CollectionViewSubject.allCases[indexPath.row] {
        case .basic:
            toVC = CollectionViewBasicViewController()
        case .dynamicHeight:
            toVC = DynamicHeightCollectionViewController()
        case .manySection:
            toVC = ManySectionViewController()
        case .horizontal:
            toVC = HorizonViewController()
        case .compositional:
            toVC = CompositionalViewController()
        case .diffableDataSource:
            toVC = DiffableViewController()
        case .stickyHeader:
            toVC = StickyHeaderViewController()
        case .banner:
            toVC = BannerViewController()
        }
        
        navigationController?.pushViewController(toVC, animated: true)
    }
}


