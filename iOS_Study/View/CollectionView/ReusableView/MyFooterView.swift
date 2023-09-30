//
//  MyFooterView.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/09/30.
//

import UIKit

final class MyFooterView: UICollectionReusableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    static let identifier = "MyFooterView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(10)
            make.top.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(text: String) {
        titleLabel.text = text
    }
    
}
