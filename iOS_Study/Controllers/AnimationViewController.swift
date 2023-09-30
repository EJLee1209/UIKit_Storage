//
//  AnimationViewController.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/09/25.
//

import UIKit

final class AnimationViewController: UIViewController {
    
    //MARK: - Properties
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
    }
    
    //MARK: - Helpers
    private func layout() {
        view.backgroundColor = .white
    }
    
}
