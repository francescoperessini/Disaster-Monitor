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
    var bodyLabel = UILabel()
        
    var didTapDoneButton: ((String) -> ())?
    
    @objc func didTapDoneButtonFunc() {
        didTapDoneButton?(messageTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
    }
        
    func setup() {
        addSubview(messageTextField)
        setupMessageTextField()
        addSubview(bodyLabel)
        setupBodyLabel()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
    func style() {
        backgroundColor = .systemGroupedBackground
        navigationItem?.title = "Message Editor"
        navigationItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButtonFunc))
        navigationItem?.rightBarButtonItem?.isEnabled = false
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.label] // cambia aspetto del titolo
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label] // cambia aspetto del titolo (con prefersLargeTitles = true)
            // navigationBar?.tintColor = .systemBlue // tintColor changes the color of the UIBarButtonItem
            navBarAppearance.backgroundColor = .secondarySystemBackground // cambia il colore dello sfondo della navigation bar
            // navigationBar?.isTranslucent = false // da provare la differenza tra true/false solo con colori vivi
            navigationBar?.standardAppearance = navBarAppearance
            navigationBar?.scrollEdgeAppearance = navBarAppearance
        } else {
            // navigationBar?.tintColor = .systemBlue
            navigationBar?.barTintColor = .secondarySystemBackground
            // navigationBar?.isTranslucent = false
        }
    }
    
    func update(oldModel: MessageEditorViewModel?) {
        guard let model = self.model else { return }
        let current = model.state.message
        
        messageTextField.placeholder = current
        
        let prepared = "This is the message that you can share on the Map Page to let your parents and friends know that you are safe!\n\n"
        bodyLabel.text = prepared + "Current message:\n\(current)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        messageTextField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        messageTextField.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor).isActive = true
        messageTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        messageTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        messageTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.topAnchor.constraint(equalTo: messageTextField.safeAreaLayoutGuide.bottomAnchor, constant: 20).isActive = true
        bodyLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
    }
    
    private func setupMessageTextField() {
        messageTextField.textColor = .label
        messageTextField.font = UIFont.systemFont(ofSize: 18)
        messageTextField.layer.borderWidth = 0.2
        messageTextField.layer.borderColor = UIColor.separator.cgColor
        messageTextField.backgroundColor = .secondarySystemGroupedBackground
        messageTextField.autocorrectionType = UITextAutocorrectionType.yes
        messageTextField.keyboardType = UIKeyboardType.default
        messageTextField.returnKeyType = UIReturnKeyType.done
        messageTextField.enablesReturnKeyAutomatically = true
        messageTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        messageTextField.leftView = setupLeftView()
        messageTextField.leftViewMode = .always
        messageTextField.delegate = self
    }

    private func setupLeftView() -> UIView {
        let leftView = UIView()
        leftView.backgroundColor = .clear
      
        let tmp = UILabel()
        tmp.text = "Message"
        tmp.textColor = .label
        tmp.font = UIFont.systemFont(ofSize: 18)
        tmp.textAlignment = .center
        
        leftView.addSubview(tmp)
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.topAnchor.constraint(equalTo: leftView.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        tmp.bottomAnchor.constraint(equalTo: leftView.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        tmp.leadingAnchor.constraint(equalTo: leftView.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        tmp.trailingAnchor.constraint(equalTo: leftView.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        return leftView
    }
    
    private func setupBodyLabel() {
        bodyLabel.numberOfLines = 0
        bodyLabel.textColor = .secondaryLabel
        bodyLabel.font = UIFont.systemFont(ofSize: 15)
        bodyLabel.textAlignment = .left
    }
    
}

extension MessageEditorView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (messageTextField.text! as NSString).replacingCharacters(in: range, with: string)
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            navigationItem?.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem?.rightBarButtonItem?.isEnabled = true
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        navigationItem?.rightBarButtonItem?.isEnabled = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextField.resignFirstResponder()
        return true
    }
    
}
