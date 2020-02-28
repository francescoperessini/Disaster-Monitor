//
//  FilterView.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 25/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Foundation
import Katana
import Tempura
import PinLayout

// MARK: - ViewModel
struct EventViewModel: ViewModelWithLocalState {
    var id: String?
    
    init(id: String) {
        self.id = id
    }
    
    init?(state: AppState?, localState: EventControllerLocalState) {
        guard let state = state else {return nil}
        self.id = localState.id
        if let id = localState.id{
            let item = state.events.first{$0.id == id}
            //print(item)
        }
    }
}


// MARK: - View
class EventView: UIView, ViewControllerModellableView {
    
    func setup() {
    }
    
    func style() {
        backgroundColor = .white
        navigationBar?.prefersLargeTitles = false
        //navigationItem?.title = "Event detail"
        //navigationItem?.title = self.model.id
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black] // cambia aspetto del titolo
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black] // cambia aspetto del titolo (con prefersLargeTitles = true)
            navigationBar?.tintColor = .black // tintColor changes the color of the UIBarButtonItem
            navBarAppearance.backgroundColor = .systemGray6 // cambia il colore dello sfondo della navigation bar
            // navigationBar?.isTranslucent = false // da provare la differenza tra true/false solo con colori vivi
            navigationBar?.standardAppearance = navBarAppearance
            navigationBar?.scrollEdgeAppearance = navBarAppearance
        } else {
            navigationBar?.tintColor = .black
            navigationBar?.barTintColor = .systemGray6
            // navigationBar?.isTranslucent = false
        }
    }

    func update(oldModel: EventViewModel?) {
        guard let model = self.model else {return}
        print(model.id)
        navigationItem?.title = model.id

    }

    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
    
    }
}
