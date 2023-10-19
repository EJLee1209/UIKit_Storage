//
//  ToggleSwitchViewController.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/10/19.
//

import UIKit

final class ToggleSwitchViewController: UIViewController {
    
    //MARK: - Properties
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "light")
        return iv
    }()
    
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0.9
        return view
    }()
    
    private let modeLabel: UILabel = {
        let label = UILabel()
        label.text = "Light Mode"
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()
    
    private let toggleView: ToggleView = .init()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        toggleView.delegate = self
    }
    
    //MARK: - Helpers
    private func layout() {
        view.backgroundColor = .white
        
        [backgroundImageView, blurView, toggleView, modeLabel].forEach(view.addSubview(_:))
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        toggleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(80)
        }
        
        modeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(toggleView.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }
    }
}

extension ToggleSwitchViewController: ToggleViewDelegate {
    func toggleView(_ toggleView: ToggleView, valueChanged value: Bool) {
        modeLabel.text = value ? "Dark Mode" : "Light Mode"
        UIView.transition(
            with: backgroundImageView,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: { self.backgroundImageView.image =  value ? UIImage(named: "dark") : UIImage(named: "light") },
            completion: nil)
    }
}
