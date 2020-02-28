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
struct EventViewModel: ViewModelWithState {
    var state: AppState
    init?(state: AppState) {
        self.state = state
    }
}


// MARK: - View
class EventView: UIView, ViewControllerModellableView {   //
    
    func setup() {
        backgroundColor = .systemGray
    }
    
    func style() {
        
    }

    func update(oldModel: EventViewModel?) {
        guard let model = self.model else {return}

    }

    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
    
    }
}
