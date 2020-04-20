//
//  MainTabBarController.swift
//  Disaster Monitor
//
//  Created by Francesco Peressini on 26/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Katana

final class MainTabBarController: UITabBarController {
    
    var store: PartialStore<AppState>!
    
    convenience init(store: PartialStore<AppState>){
        self.init()
        self.store = store
        setupTabBar()
        style()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupTabBar() {
        let mainViewController = UINavigationController(rootViewController: MainEventsTableViewController(store: store))
        mainViewController.tabBarItem.title = "Events"
        mainViewController.tabBarItem.image = UIImage(systemName: "globe")
        
        let profilePageViewController = UINavigationController(rootViewController: MapViewController(store: store))
        profilePageViewController.tabBarItem.title = "Map"
        profilePageViewController.tabBarItem.image = UIImage(systemName: "map")
        
        let settingsViewController = UINavigationController(rootViewController: SettingsViewController(store: store))
        settingsViewController.tabBarItem.title = "Settings"
        settingsViewController.tabBarItem.image = UIImage(systemName: "gear")
        
        viewControllers = [mainViewController, profilePageViewController, settingsViewController]
    }
    
    private func style() {
        //tabBar.barTintColor = #colorLiteral(red: 0.1684733033, green: 0.1724286675, blue: 0.1807242036, alpha: 1)
        //tabBar.tintColor = #colorLiteral(red: 1, green: 0.7333333333, blue: 0.2156862745, alpha: 1)
        //tabBar.isTranslucent = false
        tabBar.tintColor = .systemGray
        tabBar.unselectedItemTintColor = .systemGray3
    }
    
}
