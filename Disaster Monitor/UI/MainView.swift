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
    var state: AppState
    init?(state: AppState) {
        self.state = state
    }
}


// MARK: - View
class MainView: UIView, ViewControllerModellableView {   //

    let events = ListView()
    var didTapFilter: Interaction?
    
    @objc func didTapFilterFunc() {
        didTapFilter?()
    }
    
    func setup() {
        backgroundColor = .white
        self.addSubview(self.events)
        self.events.setup()
        self.events.style()
    }

    func style() {
    }

    func update(oldModel: MainViewModel?) {
        guard let model = self.model else { return }
        let eventListViewModel = ListViewModel(state: model.state)
        self.events.model = eventListViewModel
        self.setNeedsLayout()
    }

    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
        events.pin.top(pin.safeArea).left().right().bottom().marginTop(15)
    }
}
