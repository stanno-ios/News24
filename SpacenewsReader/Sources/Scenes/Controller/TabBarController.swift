//
//  TabBarController.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/11/22.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupViewControllers()
    }
    
    fileprivate func createNavigationController(for rootViewController: UIViewController, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = image
        return navController
    }
    
    func setupViewControllers() {
        viewControllers = [
            createNavigationController(for: NewsController(), image: UIImage(systemName: "newspaper")!),
            createNavigationController(for: SearchController(), image: UIImage(systemName: "magnifyingglass")!)
        ]
    }
}
