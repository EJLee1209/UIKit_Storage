//
//  DynamicHeightCell.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/09/25.
//

import UIKit
import SDWebImage

final class DynamicHeightCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func setupUI() {
        backgroundColor = .lightGray
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width).priority(999)
            make.height.equalTo(50).priority(999)
        }
    }
    
    func bind(imageURL: URL?) {
        guard let url = imageURL else { return }
        
        imageView.sd_setImage(with: url) { [weak self] image, _, _, _ in
            guard let image = image, let self = self else { return }
            
            imageView.snp.updateConstraints { make in
                make.width.equalTo(UIScreen.main.bounds.width).priority(999)
                make.height.equalTo(image.size.height).priority(999)
            }
            invalidateIntrinsicContentSize()
        }
    }
}
