//
//  MessageEditorView.swift
//  Disaster Monitor
//
//  Created by Francesco Peressini on 28/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura

// MARK: - ViewModel
struct MessageEditorViewModel: ViewModelWithState {
    var state: AppState
    init?(state: AppState) {
        self.state = state
    }
}

// MARK: - View
class MessageEditorView: UIView, ViewControllerModellableView {
    
    var messageTextField = UITextField()
    var currentMessage = UILabel()
  
    let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 45))
    let usernameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 45))
    
    var didTapCancelButton: (() -> ())?
    var didTapDoneButton: ((String) -> ())?

    func setup() {
        addSubview(messageTextField)
        leftView.addSubview(usernameLabel)
        addSubview(currentMessage)
    }
    
    func style() {
        backgroundColor = .white
        navigationControllerStyle()
        messageTextFieldStyle()
        usernameLabelStyle()
    }
    
    func update(oldModel: MessageEditorViewModel?) {
        messageTextField.placeholder = model?.state.message
    }
    
    override func layoutSubviews() {
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        messageTextField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        messageTextField.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor).isActive = true
        messageTextField.widthAnchor.constraint(equalToConstant: self.bounds.width).isActive = true
        messageTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    private func navigationControllerStyle() {
        navigationItem?.title = "Message Editor"
        navigationItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButtonFunc))
        navigationItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButtonFunc))
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.label] // cambia aspetto del titolo
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label] // cambia aspetto del titolo (con prefersLargeTitles = true)
            navigationBar?.tintColor = .systemBlue // tintColor changes the color of the UIBarButtonItem
            navBarAppearance.backgroundColor = .secondarySystemBackground // cambia il colore dello sfondo della navigation bar
            // navigationBar?.isTranslucent = false // da provare la differenza tra true/false solo con colori vivi
            navigationBar?.standardAppearance = navBarAppearance
            navigationBar?.scrollEdgeAppearance = navBarAppearance
        } else {
            navigationBar?.tintColor = .systemBlue
            navigationBar?.barTintColor = .secondarySystemBackground
            // navigationBar?.isTranslucent = false
        }
    }
    
    private func currentMessageStyle() {
        currentMessage.font = UIFont.systemFont(ofSize: 15)
    }
    
    private func messageTextFieldStyle() {
        messageTextField.placeholder = "Enter your new message here..."
        messageTextField.textColor = .label
        messageTextField.font = UIFont.systemFont(ofSize: 18)
        messageTextField.layer.borderWidth = 0.5
        messageTextField.layer.borderColor = UIColor.separator.cgColor
        messageTextField.backgroundColor = .systemBackground
        messageTextField.autocorrectionType = UITextAutocorrectionType.yes
        messageTextField.keyboardType = UIKeyboardType.default
        messageTextField.returnKeyType = UIReturnKeyType.done
        messageTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        messageTextField.delegate = self

        messageTextField.leftView = leftView
        messageTextField.leftViewMode = .always
    }
    
    private func usernameLabelStyle() {
        usernameLabel.text = "Message"
        usernameLabel.textColor = .label
        usernameLabel.font = UIFont.systemFont(ofSize: 18)
        usernameLabel.textAlignment = .center
    }
    
    @objc func didTapCancelButtonFunc() {
        didTapCancelButton?()
    }
    
    @objc func didTapDoneButtonFunc() {
        didTapDoneButton?("test")
    }
    
}

extension MessageEditorView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextField.resignFirstResponder()
        return true
    }
    
}
