//
//  TabController.swift
//  AppStoreProject
//
//  Created by Joy Kim on 8/8/24.
//

import UIKit

class TabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .blue
        tabBar.unselectedItemTintColor = .darkGray
        view.backgroundColor = .white
        
      
        let tap0 = UINavigationController(rootViewController: secondTabVC())
        tap0.tabBarItem = UITabBarItem(title: "투데이", image: UIImage(systemName: "book"), tag: 0 )
       
        let tap1 = UINavigationController(rootViewController: thirdTabVC())
        tap1.tabBarItem = UITabBarItem(title: "게임", image: UIImage(systemName: "gamecontroller"), tag: 1 )
        
        let tap2 = UINavigationController(rootViewController: fourthTabVC())
        tap2.tabBarItem = UITabBarItem(title: "앱", image: UIImage(systemName: "square.stack.fill"), tag: 2 )
        
        let tap3 = UINavigationController(rootViewController: fifthTabVC())
        tap3.tabBarItem = UITabBarItem(title: "아케이드", image: UIImage(systemName: "star"), tag: 3 )
        
        let tap4 = UINavigationController(rootViewController: SearchTabMainViewController())
        tap4.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 4 )
        
        setViewControllers([tap0, tap1, tap2, tap3, tap4], animated: true)
    }
}
