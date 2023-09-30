//
//  MyHeaderView.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/09/30.
//

import UIKit

final class MyHeaderView: UICollectionReusableView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        return label
    }()
    
    static let identifier = "MyHeaderView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(text: String) {
        titleLabel.text = text
    }
}
