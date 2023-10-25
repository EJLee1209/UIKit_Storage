//
//  StickyHeaderViewController.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/10/03.
//

import UIKit

class StickyHeaderViewController: UIViewController {
    //MARK: - Properties
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.clipsToBounds = true
        cv.backgroundColor = .clear
        cv.contentInsetAdjustmentBehavior = .never
        cv.contentInset = .init(top: headerHeight, left: 0, bottom: 0, right: 0)
        cv.register(BasicCell.self, forCellWithReuseIdentifier: BasicCell.identifier)
        cv.register(MyHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyHeaderView.identifier)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private let headerImageView: UIImageView = {
      let view = UIImageView()
      view.image = UIImage(named: "cat")
      view.clipsToBounds = true
      view.contentMode = .scaleAspectFill
      return view
    }()
    
    private let stickyView: StickyHeaderView = .init()
    
    private var stickyViewFrame: CGRect?
    private let headerHeight = 300.0
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        hideNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        showNavBar()
    }
    
    //MARK: - Helpers
    private func layout() {
        view.backgroundColor = .white
        [collectionView, headerImageView, stickyView].forEach(view.addSubview)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headerImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(headerHeight)
        }
        
        stickyView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        stickyView.isHidden = true
    }
    
    private func showNavBar() {
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.setBackgroundImage(nil, for: .default) // 배경 이미지 복원
            navigationBar.shadowImage = nil // 그림자 이미지 복원
        }
    }
    private func hideNavBar() {
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
        }
    }
}


//MARK: - UICollectionViewDataSource
extension StickyHeaderViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicCell.identifier, for: indexPath) as! BasicCell
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if indexPath.section == 1 {
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: MyHeaderView.identifier,
                    for: indexPath
                ) as! MyHeaderView
                header.bind(text: "StickyHeader")
                self.stickyViewFrame = header.frame
                
                return header
            } else {
                fatalError()
            }
        default:
            fatalError()
        }
    }
}

extension StickyHeaderViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let distanceFromOrigin = abs(scrollView.contentOffset.y) // 스크롤뷰의 원점에서 현재 스크롤 offset.y 의 거리
        let scrollUp = scrollView.contentOffset.y <= -headerHeight // 이미 스크롤이 원점인 상태에서 위로 스크롤 중인가?
        let stopExpandHeader = scrollView.contentOffset.y <= -(headerHeight*2) // 이미지 확장을 멈춰야 하는가?
        
        if !stopExpandHeader, scrollUp {
            // 이미지 확장 가능하고, 이미 스크롤이 원점인 상태에서 위로 스크롤 중
            headerImageView.snp.updateConstraints { make in
                make.height.equalTo(distanceFromOrigin)
            }
            headerImageView.alpha = 1
        }
        else if !scrollUp {
            // 아래로 스크롤 중
            let height = scrollView.contentOffset.y <= 0 ? distanceFromOrigin : 0
            headerImageView.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
            
            headerImageView.alpha = distanceFromOrigin / headerHeight
        }
        
        if scrollView.contentOffset.y >= 0 {
            showNavBar()
        } else {
            hideNavBar()
        }
        
        print("DEBUG scrollview offset y : \(scrollView.contentOffset.y)")
        guard let stickyFrame = stickyViewFrame else { return }
        
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let topSafeAreaInsetHeight = statusBarHeight + navigationBarHeight
        
        let stickyViewOffsetY = stickyFrame.minY - topSafeAreaInsetHeight
        
        let stickyViewIsHidden = scrollView.contentOffset.y < stickyViewOffsetY
        self.stickyView.isHidden = stickyViewIsHidden
    }

}

//MARK: - UICollectionViewDelegateFlowLayout
extension StickyHeaderViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return .init(width: self.view.frame.width, height: 150)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 1:
            return .init(width: self.view.frame.width, height: 50)
        default:
            return .zero
        }
    
    }
}
