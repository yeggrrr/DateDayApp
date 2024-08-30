//
//  DateDayTabBarController.swift
//  DateDayApp
//
//  Created by YJ on 8/18/24.
//

import UIKit

final class DateDayTabBarController: UITabBarController {
    var showLoginAlert: Bool
    
    init(showLoginAlert: Bool) {
        self.showLoginAlert = showLoginAlert
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
    }
    
    private func configureTabBar() {
        tabBar.backgroundColor = .primaryCustomLight
        tabBar.isTranslucent = false
        tabBar.tintColor = .primaryDark
        tabBar.unselectedItemTintColor = .darkGray
        
        let feedVC = FeedViewController()
        feedVC.showLoginAlert = showLoginAlert
        let feedNav = UINavigationController(rootViewController: feedVC)
        feedNav.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "scribble"), selectedImage: UIImage(systemName: "scribble.variable"))
        
        let myPageVC = MyPageViewController()
        let myPageNav = UINavigationController(rootViewController: myPageVC)
        myPageNav.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        setViewControllers([feedNav, myPageNav], animated: true)
    }
}
