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
class SettingsView: UIView, ViewControllerModellableView {
    let settingsLabel = UILabel()

    func setup() {
        backgroundColor = .systemBackground
        self.addSubview(self.settingsLabel)
        
    }

    // style
    func style() {
        
    }

    // update
    func update(oldModel: MainViewModel?) {
       
    }

    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
        self.settingsLabel.pin.top(0).left(20).sizeToFit()
        self.settingsLabel.text = "SETTINGS"
    }
}
