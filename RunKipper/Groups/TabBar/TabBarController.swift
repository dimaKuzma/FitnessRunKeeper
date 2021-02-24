//
//  TabBarController.swift
//  RunKipper
//
//  Created by Дмитрий on 12/18/20.
//  Copyright © 2020 DK. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    // - DATA
    let selectedIconsColor = UIColor(red: 0.14902, green: 0.72941, blue: 0.75686, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: -
// MARK: - Configure
private extension TabBarController {
    func configure() {
        configureTabBar()
    }
    
    func configureTabBar() {
        let iVC = UIStoryboard(name: "I", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let firstTabBarItem = UITabBarItem()
        firstTabBarItem.title = "Я"
        firstTabBarItem.image = UIImage(named: "smile")?.withRenderingMode(.alwaysOriginal)
        firstTabBarItem.selectedImage = UIImage(named: "smileSelected")?.withRenderingMode(.alwaysOriginal)
        firstTabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedIconsColor], for:.selected)
        iVC.tabBarItem = firstTabBarItem
        let workoutsVC = UIStoryboard(name: "News", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let secondTabBarItem = UITabBarItem()
        secondTabBarItem.title = "Тренировки"
        secondTabBarItem.image = UIImage(named: "clipboard")?.withRenderingMode(.alwaysOriginal)
        secondTabBarItem.selectedImage = UIImage(named: "clipboardSelected")?.withRenderingMode(.alwaysOriginal)
        secondTabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedIconsColor], for:.selected)
        workoutsVC.tabBarItem = secondTabBarItem
        let startVC = UIStoryboard(name: "Start", bundle: nil).instantiateInitialViewController() as! StartViewController
        let thirdTabBarItem = UITabBarItem()
        thirdTabBarItem.title = "Старт"
        thirdTabBarItem.image = UIImage(named: "location-pointer")?.withRenderingMode(.alwaysOriginal)
        thirdTabBarItem.selectedImage = UIImage(named: "location-pointerSelected")?.withRenderingMode(.alwaysOriginal)
        thirdTabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedIconsColor], for:.selected)
        startVC.tabBarItem = thirdTabBarItem
        viewControllers = [iVC, workoutsVC, startVC]
    }
}

