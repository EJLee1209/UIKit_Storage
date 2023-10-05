//
//  AlertViewController.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/10/05.
//

import UIKit

class AlertViewController: UIViewController {
    
    //MARK: - Properties
    private lazy var alertButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Alert (Alert Style)", for: .normal)
        button.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var actionSheetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Alert (Action Sheet Style)", for: .normal)
        button.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [alertButton, actionSheetButton])
        sv.axis = .vertical
        sv.spacing = 10
        return sv
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    //MARK: - Helpers
    private func layout() {
        view.backgroundColor = .white
        
        view.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func showAlert(alertStyle: UIAlertController.Style) {
        let alertController = UIAlertController(title: "Alert", message: "alert", preferredStyle: alertStyle)
        let positiveAction = UIAlertAction(title: "Ok", style: .default) { _ in
            print("Ok")
        }
        let negativeAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        
        [positiveAction, negativeAction].forEach(alertController.addAction(_:))
        
        self.present(alertController, animated: true)
    }

    //MARK: - Actions
    @objc private func handleButtonTapped(_ button: UIButton) {
        if button == alertButton {
            showAlert(alertStyle: .alert)
        } else {
            showAlert(alertStyle: .actionSheet)
        }
    }
}

