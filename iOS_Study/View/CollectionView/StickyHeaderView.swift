//
//  StickyHeaderView.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/10/03.
//

import UIKit

final class StickyHeaderView: UIView {
    private let stickyHeaderBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let stickyHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.text = "StickyHeader"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stickyHeaderBackgroundView)
        stickyHeaderBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stickyHeaderBackgroundView.addSubview(stickyHeaderLabel)
        stickyHeaderLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
