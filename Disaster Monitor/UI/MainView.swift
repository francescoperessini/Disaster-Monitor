//
//  MainView.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 17/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import Foundation
import Katana
import Tempura

// MARK: - ViewModel
struct MainViewModel: ViewModelWithState {
    // Per ogni schermo c'è una sola view con un ViewModelWithState
    var descr: String
    init?(state: AppState) {
        self.descr = "Bella"
    }

}


// MARK: - View
class MainView: UIView, ViewControllerModellableView {   //
   
    let title = UILabel()
    let container = UIView()
    
    let event = AttractionCell()
    
    
    // setup
    func setup() {      // 1. Assemblaggio della view, chiamata una volta sola
        backgroundColor = .white
        addSubview(title)
        addSubview(container)
        addSubview(event)
        
    }

    // style
    func style() {      // 2. Cosmetics, chiamata una sola volta
        self.title.text = "Home Page"
        self.title.font = UIFont(name: "Futura-Bold", size: 25)
    }

    // update
    func update(oldModel: MainViewModel?) {  // Chiamato ad ogni aggiornamento di stato

    }

    // layout
    override func layoutSubviews() {
        title.pin.top(pin.safeArea).left(pin.safeArea).width(100).aspectRatio().margin(20).sizeToFit()
        
    }
}


final class MainTabbar : UITabBarController{
    var store: PartialStore<AppState>!
    
    lazy var home1ViewController: UIViewController = {
        let v = MainViewController(store: store)
        v.tabBarItem.title = "Home"
        v.tabBarItem.image = UIImage(systemName: "house.fill")
        return v
    }()
    
    lazy var home2ViewController: UIViewController = {
        let v = UIViewController()
        v.view.backgroundColor = .green
        v.tabBarItem.title = "My Profile"
        v.tabBarItem.image = UIImage(systemName: "person.fill")
        return v
    }()
    
    lazy var home3ViewController: UIViewController = {
        let v = UIViewController()
        v.view.backgroundColor = .purple
        v.tabBarItem.title = "My Profile"
        v.tabBarItem.image = UIImage(systemName: "gear")
        return v
    }()
    

    convenience init(store: PartialStore<AppState>){
        self.init()
        self.store = store
        self.setup()
    }
    
    private func setup(){
        self.viewControllers=[
            self.home1ViewController,
            self.home2ViewController,
            self.home3ViewController
        ]
    }
}
