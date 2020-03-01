//
//  MessageEditorViewController.swift
//  Disaster Monitor
//
//  Created by Francesco Peressini on 28/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura

// MARK: - ViewController
class MessageEditorViewController: ViewController<MessageEditorView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupInteraction() {
        rootView.didTapCancelButton = {
            self.dismiss(animated: true, completion: nil)
        }
        
        rootView.didTapDoneButton = { [unowned self] message in
            self.dispatch(SetMessage(newMessage: message))
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
