//
//  CustomViewController.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/10/19.
//

import UIKit

final class CustomViewController: UIViewController {
    
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
        navigationItem.title = "Custom View"
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
}

//MARK: - UITableViewDataSource
extension CustomViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CustomViewSubject.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = CustomViewSubject.allCases[indexPath.row].rawValue
        return cell
    }
}


extension CustomViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var toVC: UIViewController
        
        switch CustomViewSubject.allCases[indexPath.row] {
        case .slider:
            toVC = SliderViewController()
        case .toggleSwitch:
            toVC = ToggleSwitchViewController()
        }
        
        navigationController?.pushViewController(toVC, animated: true)
    }
    
}
