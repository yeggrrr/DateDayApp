//
//  DateDayTabBarController.swift
//  DateDayApp
//
//  Created by YJ on 8/18/24.
//

import UIKit

final class DateDayTabBarController: UITabBarController {
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
        let feedNav = UINavigationController(rootViewController: feedVC)
        feedNav.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "scribble"), selectedImage: UIImage(systemName: "scribble.variable"))
        
        let pickedListVC = PickedListViewController()
        let pickedListNav = UINavigationController(rootViewController: pickedListVC)
        pickedListNav.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "bookmark"), selectedImage: UIImage(systemName: "bookmark.fill"))
        
        
        let myPageVC = MyPageViewController()
        let myPageNav = UINavigationController(rootViewController: myPageVC)
        myPageNav.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        setViewControllers([feedNav, pickedListNav, myPageNav], animated: true)
    }
}
