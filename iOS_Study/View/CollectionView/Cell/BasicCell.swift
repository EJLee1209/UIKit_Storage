//
//  BasicCell.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/09/30.
//

import UIKit

final class BasicCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    static let identifier = "BasicCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBlue
        clipsToBounds = true
        layer.cornerRadius = 12
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(imageUrl: URL?) {
        imageView.sd_setImage(with: imageUrl)
    }
}
