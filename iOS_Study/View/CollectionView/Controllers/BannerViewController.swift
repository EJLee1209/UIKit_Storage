//
//  PageControllerViewController.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/10/04.
//

import UIKit
import Combine

class BannerViewController: UIViewController {
    //MARK: - Properties
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.makeFlowLayout())
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.register(BasicCell.self, forCellWithReuseIdentifier: BasicCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        cv.clipsToBounds = true
        return cv
    }()
    
    private lazy var pageController: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = currentPage - 1
        control.numberOfPages = dataSource.count - 2
        control.pageIndicatorTintColor = .lightGray // 페이지를 암시하는 동그란 점의 색상
        control.currentPageIndicatorTintColor = .systemBlue // 현재 페이지를 암시하는 동그란 점 색상
        return control
    }()
    
    private lazy var dataSource = (1...5).map { "Cell \($0)" }

    private lazy var cellSize = self.view.frame.width
    private var currentPage: Int = 1 {
        didSet {
            pageController.currentPage = currentPage == dataSource.count - 1 ? 0 : currentPage - 1
        }
    }
    private var cancellables: Set<AnyCancellable> = .init()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [1,2,3,4,5] => [5,1,2,3,4,5,1]
        dataSource.insert(dataSource[dataSource.count - 1], at: 0)
        dataSource.append(dataSource[1])
        layout()
        addTimer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.selectItem(at: .init(row: 1, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }
    
    //MARK: - Helpers
    
    private func layout() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(cellSize)
        }
        
        view.addSubview(pageController)
        pageController.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        
    }
    
    private func makeFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: cellSize, height: cellSize)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }
    
    private func addTimer() {
        Timer.publish(every: 3.0, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [unowned self] _ in
                let tmp = (currentPage + 1) % dataSource.count
                currentPage = tmp == 0 ? 1 : tmp
                let indexPath = IndexPath(row: currentPage, section: 0)
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            })
            .store(in: &cancellables)
    }
    
}


//MARK: - UICollectionViewDataSource
extension BannerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicCell.identifier, for: indexPath) as! BasicCell
        cell.bind(label: dataSource[indexPath.row])
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate
extension BannerViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let count = dataSource.count
        let currentOffsetX = scrollView.contentOffset.x
        let lastBannerOffsetX = CGFloat(count - 1) * cellSize
        
        if currentOffsetX == 0 {
            // 마지막 item으로 이동
            collectionView.scrollToItem(at: .init(row: count - 2, section: 0), at: .centeredHorizontally, animated: false)
        }
        
        else if currentOffsetX == lastBannerOffsetX {
            // 첫번째 item으로 이동
            collectionView.scrollToItem(at: .init(row: 1, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if targetContentOffset.pointee.x == 0 {
            self.currentPage = dataSource.count - 2
        } else {
            self.currentPage = Int(targetContentOffset.pointee.x / cellSize)
        }
        
    }
}
