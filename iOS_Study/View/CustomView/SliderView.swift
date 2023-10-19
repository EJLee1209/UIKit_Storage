//
//  SliderView.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/10/18.
//

import UIKit

//MARK: - SliderView.swift
protocol SliderViewDelegate: AnyObject {
    func sliderView(_ sender: SliderView, changedValue value: Int)
}

final class SliderView: UIView {
    
    //MARK: - Properties
    private let trackView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private lazy var thumbView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.isUserInteractionEnabled = true
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(gesture)
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = .init(width: 3, height: 3)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.8
        return view
    }()
    
    private let fillTrackView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    private var dividers: [UIView] = []
    
    private var maxValue: Int
    private var touchBeganPosX: CGFloat?
    private var didLayoutSubViews: Bool = false
    
    private let thumbSize: CGFloat = 30
    private let dividerWidth: CGFloat = 8
    
    weak var delegate: SliderViewDelegate?
    
    override var intrinsicContentSize: CGSize {
        return .init(width: .zero, height: thumbSize)
    }
    
    var value: Int = 1 {
        didSet {
            delegate?.sliderView(self, changedValue: value)
        }
    }
    
    //MARK: - LifeCycle
    init(maxValue: Int) {
        if maxValue < 1 {
            self.maxValue = 1
        }
        else if maxValue > 20 {
            self.maxValue = 20
        }
        else{
            self.maxValue = maxValue
        }
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !didLayoutSubViews {
            makeDivider(maxValue)
            thumbView.layer.cornerRadius = thumbView.frame.width / 2
            thumbView.layer.shadowPath = UIBezierPath(
                roundedRect: thumbView.bounds,
                cornerRadius: thumbView.layer.cornerRadius
            ).cgPath
        }
    }
    
    //MARK: - Helpers
    private func layout() {
        [trackView, fillTrackView, thumbView].forEach(addSubview)
        
        trackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.verticalEdges.equalToSuperview().inset(10)
        }
        thumbView.snp.makeConstraints { make in
            make.centerY.equalTo(trackView)
            make.left.equalTo(trackView).offset(-(thumbSize / 2))
            make.size.equalTo(thumbSize)
        }
        fillTrackView.snp.makeConstraints { make in
            make.left.equalTo(trackView)
            make.top.bottom.equalTo(trackView)
            make.width.equalTo(0)
        }
    }
    
    private func makeDivider(_ numberOfDivider: Int) {
        let slicedPosX = trackView.frame.width / CGFloat(numberOfDivider - 1)
        
        for i in 0..<numberOfDivider {
            let dividerPosX = slicedPosX * CGFloat(i)
            let divider = makeDivider()
            
            trackView.addSubview(divider)
            divider.snp.makeConstraints { make in
                make.centerY.equalTo(trackView)
                make.left.equalTo(trackView).offset(dividerPosX - 4)
                make.width.equalTo(dividerWidth)
                make.height.equalTo(trackView).offset(7)
            }
        }
        
        didLayoutSubViews.toggle()
    }
    
    private func makeDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = .systemGray5
        divider.clipsToBounds = true
        divider.layer.cornerRadius = 3
        dividers.append(divider)
        return divider
    }
    
    //MARK: - Actions
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: thumbView)
        
        if recognizer.state == .began {
            // 팬 제스쳐가 시작된 x좌표 저장
            touchBeganPosX = thumbView.frame.minX
        }
        if recognizer.state == .changed {
            guard let startX = self.touchBeganPosX else { return }
            
            var offSet = startX + translation.x // 시작지점 + 제스쳐 거리 = 현재 제스쳐 좌표
            if offSet < 0 || offSet > trackView.frame.width { return } // 제스쳐가 trackView의 범위를 벗어나는 경우 무시
            let slicedPosX = trackView.frame.width / CGFloat(maxValue - 1) // maxValue를 기준으로 trackView를 n등분
            
            // value = 반올림(현재 제스쳐 좌표 / 1단위의 크기) -> 슬라이더의 값이 변할 때마다 똑똑 끊기는 효과를 주기 위해
            let newValue = round(offSet / slicedPosX)
            offSet = slicedPosX * newValue - (thumbSize / 2)
            
            thumbView.snp.updateConstraints { make in
                make.left.equalTo(trackView).offset(offSet)
            }
            fillTrackView.snp.updateConstraints { make in
                make.width.equalTo(offSet)
            }
            
            if value != Int(newValue + 1) {
                value = Int(newValue + 1)
                for i in 0..<value {
                    dividers[i].backgroundColor = .systemBlue
                }
                for i in value..<maxValue {
                    dividers[i].backgroundColor = .systemGray5
                }
            }
        }
    }

}
