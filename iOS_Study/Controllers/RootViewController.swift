//
//  RootViewController.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/09/25.
//



import UIKit
import SnapKit

final class RootViewController: UIViewController {
    
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
        navigationItem.title = "iOS Study"
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
}

//MARK: - UITableViewDataSource
extension RootViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        StudySubject.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = StudySubject.allCases[indexPath.row].rawValue
        return cell
    }
}

//MARK: - UITableViewDelegate
extension RootViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        switch StudySubject.allCases[indexPath.row] {
        case .CollectionView:
            let toVC = CollectionViewController()
            navigationController?.pushViewController(toVC, animated: true)
        case .animation:
            let toVC = AnimationViewController()
            navigationController?.pushViewController(toVC, animated: true)
        }
    }
}
