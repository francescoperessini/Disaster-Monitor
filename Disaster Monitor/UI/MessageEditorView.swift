//
//  MessageEditorView.swift
//  Disaster Monitor
//
//  Created by Francesco Peressini on 28/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Katana
import Tempura
import PinLayout

// MARK: - ViewModel
struct MessageEditorViewModel: ViewModelWithState {
    var state: AppState
    init?(state: AppState) {
        self.state = state
    }
}

// MARK: - View
class MessageEditorView: UIView, ViewControllerModellableView {
    
    var didTapCancelButton: (() -> ())?

    func setup() {
    }
    
    func style() {
        backgroundColor = .systemBackground
        navigationItem?.title = "Message Editor"
        navigationItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButtonFunc))
        navigationItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapCancelButtonFunc))
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            /*
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: "FuturaStd-Bold", size: 30) ??
            UIFont.boldSystemFont(ofSize: 30)] // cambia aspetto del titolo
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: "FuturaStd-Bold", size: 30) ??
            UIFont.boldSystemFont(ofSize: 30)] // cambia aspetto del titolo (con prefersLargeTitles = true)
            */
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black] // cambia aspetto del titolo
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black] // cambia aspetto del titolo (con prefersLargeTitles = true)
            navigationBar?.tintColor = .systemBlue // tintColor changes the color of the UIBarButtonItem
            navBarAppearance.backgroundColor = .systemGray6 // cambia il colore dello sfondo della navigation bar
            // navigationBar?.isTranslucent = false // da provare la differenza tra true/false solo con colori vivi
            navigationBar?.standardAppearance = navBarAppearance
            navigationBar?.scrollEdgeAppearance = navBarAppearance
        } else {
            navigationBar?.tintColor = .systemBlue
            navigationBar?.barTintColor = .systemGray6
            // navigationBar?.isTranslucent = false
        }
    }
    
    func update(oldModel: MessageEditorViewModel?) {
        
    }
    
    @objc func didTapCancelButtonFunc() {
        didTapCancelButton?()
    }
    
}
