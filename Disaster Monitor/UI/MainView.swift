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
        self.descr = "\(state.num)"
    }
}


// MARK: - View
class MainView: UIView, ViewControllerModellableView {   //
   
    let title = UILabel()
    let filter = UIButton()
    let container = UIView()
    let events = ListView()
    
    var didTapFilter: Interaction?
    
    @objc func didTapFilterFunc() {
        didTapFilter?()
    }
    
    
    // setup
    func setup() {      // 1. Assemblaggio della view, chiamata una volta sola
        backgroundColor = .white
        self.addSubview(self.title)
        self.addSubview(self.container)
        self.addSubview(self.events)
        self.addSubview(self.filter)
        self.events.setup()
        self.events.style()
        filter.addTarget(self, action: #selector(didTapFilterFunc), for: .touchUpInside)
    }

    // style
    func style() {      // 2. Cosmetics, chiamata una sola volta
        self.title.text = "Home Page"
        self.title.font = UIFont(name: "Futura-Bold", size: 25)
        
    }

    // update
    func update(oldModel: MainViewModel?) {  // Chiamato ad ogni aggiornamento di stato
        guard let model = self.model else { return }
        let eventListViewModel = ListViewModel()
        self.events.model = eventListViewModel
        self.setNeedsLayout()
    }

    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
        title.pin.top(pin.safeArea).left(pin.safeArea).width(100).aspectRatio().margin(20).sizeToFit()
        filter.pin.after(of: title).top(pin.safeArea).marginLeft(190).marginTop(20).width(50).height(50)
        filter.setImage(UIImage(systemName: "line.horizontal.3.decrease.circle")!, for: .normal)
        filter.tintColor = .systemGray2
        events.pin.below(of: title).left().right().bottom().marginTop(15)
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
        let v = ProfileViewController(store: store)
        v.tabBarItem.title = "My Profile"
        v.tabBarItem.image = UIImage(systemName: "person.fill")
        return v
    }()
    
    lazy var home3ViewController: UIViewController = {
        let v = UIViewController()
        v.view.backgroundColor = .purple
        v.tabBarItem.title = "Settings"
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
