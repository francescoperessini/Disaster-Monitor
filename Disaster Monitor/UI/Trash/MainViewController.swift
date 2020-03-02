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
class MainViewController: ViewController<MainView> {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Main Events"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(openFilter))

        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: "FuturaStd-Bold", size: 30) ??
            UIFont.boldSystemFont(ofSize: 30)] // cambia aspetto del titolo
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: "FuturaStd-Bold", size: 30) ??
            UIFont.boldSystemFont(ofSize: 30)] // cambia aspetto del titolo (con prefersLargeTitles = true)
            navigationController?.navigationBar.tintColor = .black // tintColor changes the color of the UIBarButtonItem
            navBarAppearance.backgroundColor = .systemGray6 // cambia il colore dello sfondo della navigation bar
            // navigationController?.navigationBar.isTranslucent = false // da provare la differenza tra true/false solo con colori vivi
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            navigationController?.navigationBar.tintColor = .black
            navigationController?.navigationBar.barTintColor = .systemGray6
            // navigationController?.navigationBar.isTranslucent = false
        }
        
        self.dispatch(GetEvents())
    }
    
    @objc override func setupInteraction() {
        //self.dispatch(GetEvent())
        //self.dispatch(FilterEvent())
        //print(store.state)
        
    }
    
    @objc func openFilter(){
        let vc = FilterViewController(store: store)
        self.present(vc, animated: true, completion: nil)
    }
    
}

enum Screen: String {
    case home
}
