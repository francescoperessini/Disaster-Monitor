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
        let rightButtonView = UIView.init(frame: CGRect(x: 0, y: 0, width: 70, height: 50))
        let rightButton = UIButton.init(type: .system)
        rightButton.backgroundColor = .clear
        rightButton.frame = rightButtonView.frame
        rightButton.setTitle("Filters", for: .normal)
        rightButton.tintColor = .black
        rightButton.autoresizesSubviews = true
        rightButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        rightButton.addTarget(self, action: #selector(foo), for: .touchUpInside)
        rightButtonView.addSubview(rightButton)
        let leftBarButton = UIBarButtonItem.init(customView: rightButtonView)
        self.navigationItem.rightBarButtonItem = leftBarButton
        
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
        //self.dispatch(GetEvent())
        //self.dispatch(FilterEvent())
        //print(store.state)
        
    }
    
    @objc func foo(){
        let vc = FilterViewController(store: store)
        self.present(vc, animated: true, completion: nil)
    }
    
}

enum Screen: String {
    case home
}
