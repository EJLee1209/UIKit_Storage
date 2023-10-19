//
//  CustomViewController.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/10/18.
//

import UIKit

//MARK: - CustomViewController.swift
final class SliderViewController: UIViewController {
    
    //MARK: - Properties
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()
    
    private let sliderView: SliderView = .init(maxValue: 5)
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        sliderView.delegate = self
    }
    
    //MARK: - Helpers
    private func layout() {
        view.backgroundColor = .white
        view.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        view.addSubview(sliderView)
        sliderView.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        
    }
    
    
}

extension SliderViewController: SliderViewDelegate {
    func sliderView(_ sender: SliderView, changedValue value: Int) {
        mainLabel.text = "\(value)"
    }
}
