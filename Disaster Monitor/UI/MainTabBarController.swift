//
//  MainTabBarController.swift
//  Disaster Monitor
//
//  Created by Francesco Peressini on 26/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Katana

class MainTabBarController: UITabBarController {

    var store: PartialStore<AppState>!
    
    convenience init(store: PartialStore<AppState>){
        self.init()
        self.store = store
        setupTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupTabBar() {
        let mainViewController = UINavigationController(rootViewController: MainEventsTableViewController(store: store))
        mainViewController.tabBarItem.title = "Events"
        mainViewController.tabBarItem.image = UIImage(systemName: "globe")
        
        let profilePageViewController = UINavigationController(rootViewController: ProfileViewController(store: store))
        profilePageViewController.tabBarItem.title = "Profile"
        profilePageViewController.tabBarItem.image = UIImage(systemName: "person")
        
        let settingsViewController = UINavigationController(rootViewController: SettingsViewController(store: store))
        settingsViewController.tabBarItem.title = "Settings"
        settingsViewController.tabBarItem.image = UIImage(systemName: "gear")
        
        viewControllers = [mainViewController, profilePageViewController, settingsViewController]
    }
    
}
