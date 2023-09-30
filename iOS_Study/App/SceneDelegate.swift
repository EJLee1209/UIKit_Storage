//
//  SceneDelegate.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/09/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let rootVC = RootViewController()
        let nav = UINavigationController(rootViewController: rootVC)
        window.rootViewController = nav
        
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

