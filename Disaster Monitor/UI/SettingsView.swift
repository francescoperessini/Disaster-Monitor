//
//  SettingsView.swift
//  Disaster Monitor
//
//  Created by Francesco Peressini on 19/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import Foundation
import Katana
import Tempura


// MARK: - ViewModel
struct SettingsViewModel: ViewModelWithState {
    // Per ogni schermo c'è una sola view con un ViewModelWithState
    var name: String
    var surname: String
    init?(state: AppState) {
        self.name = "\(state.name)"
        self.surname = "\(state.surname)"
    }
}


// MARK: - View
class SettingsView: UIView, ViewControllerModellableView {   //
   
    let settingsTableView = UITableView()
    
    
    // setup
    func setup() {      // 1. Assemblaggio della view, chiamata una volta sola
        backgroundColor = .systemBackground
        
    }

    // style
    func style() {      // 2. Cosmetics, chiamata una sola volta
        
    }

    // update
    func update(oldModel: MainViewModel?) {  // Chiamato ad ogni aggiornamento di stato
       
    }

    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
