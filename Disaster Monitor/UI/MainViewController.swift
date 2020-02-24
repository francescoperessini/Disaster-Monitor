//
//  MainViewController.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 17/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import UIKit
import Katana
import Tempura
import PinLayout


// MARK: - View Controller
// Ha la responsabilità di passare alla view un nuovo viewmodel a ogni update
class MainViewController: ViewController<MainView> {  // Extension of UIViewController
    
    override func viewWillAppear(_ animated: Bool) {
        self.dispatch(GetEvent())
        super.viewWillAppear(animated)
        self.navigationItem.title = "Main Events"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(setupInteraction))
        
        // TODO: Rivedere questo pezzo di codice perché molto dubbio
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = .systemGray6
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
               
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        
        self.dispatch(GetEvent())
    }
    
    @objc override func setupInteraction() {
        // self.dispatch(GetEvent())
        self.dispatch(FilterEvent())
    }
    
}

enum Screen: String {
    case home
}
