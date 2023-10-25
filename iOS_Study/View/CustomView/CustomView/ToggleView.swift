//
//  ToggleView.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/10/19.
//

import UIKit

protocol ToggleViewDelegate: AnyObject {
    func toggleView(_ toggleView: ToggleView, valueChanged value: Bool)
}

final class ToggleView: UIView {
    
    //MARK: - Properties
    
    private let thumbView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let trackView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    private let trackImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "light")
        return iv
    }()
    
    override var intrinsicContentSize: CGSize {
        return trackView.frame.size
    }
    
    private var isOn: Bool = false {
        didSet {
            updateUI()
            delegate?.toggleView(self, valueChanged: isOn)
        }
    }
    
    private var didLayoutSubviews: Bool = false
    
    weak var delegate: ToggleViewDelegate?
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        addTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutIfNeeded()
        if !didLayoutSubviews {
            trackView.layer.cornerRadius = trackView.frame.height / 2
            thumbView.layer.cornerRadius = thumbView.frame.height / 2
            trackImageView.layer.cornerRadius = trackView.frame.height / 2
            
            didLayoutSubviews.toggle()
        }
        
    }
    
    //MARK: - Helpers
    private func layout() {
        addSubview(trackView)
        [trackImageView, thumbView].forEach(addSubview(_:))
        
        trackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        thumbView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(5)
            make.width.equalTo(thumbView.snp.height)
        }
        
        trackImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func addTapGesture() {
        let gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapped)
        )
        self.addGestureRecognizer(gesture)
    }
    
    private func updateUI() {
        if isOn {
            thumbView.snp.remakeConstraints { make in
                make.right.top.bottom.equalToSuperview().inset(5)
                make.width.equalTo(thumbView.snp.height)
            }
        } else {
            thumbView.snp.remakeConstraints { make in
                make.left.top.bottom.equalToSuperview().inset(5)
                make.width.equalTo(thumbView.snp.height)
            }
        }
        
        UIView.animate(withDuration: 0.5, animations: layoutIfNeeded)
        
        UIView.transition(
            with: trackImageView,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                self?.trackImageView.image = self?.isOn ?? false ? UIImage(named: "dark") : UIImage(named: "light")
            },
            completion: nil)
    }
    
    //MARK: - Actions
    
    @objc private func handleTapped(_ sender: UITapGestureRecognizer) {
        isOn.toggle()
    }
}
