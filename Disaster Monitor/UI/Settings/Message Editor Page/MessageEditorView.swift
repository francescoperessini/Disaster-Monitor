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
    
    var messageTextView = UITextView()
    var bodyLabel = UILabel()
    
    var currentMessage: String = ""
    
    var didTapCloseButton: (() -> ())?
    
    @objc func didTapCloseButtonFunc() {
        didTapCloseButton?()
    }
        
    var didTapDoneButton: ((String) -> ())?
    
    @objc func didTapDoneButtonFunc() {
        didTapDoneButton?(messageTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines))
    }
        
    func setup() {
        addSubview(messageTextView)
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
        navigationItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseButtonFunc))
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
        currentMessage = model.state.message

        if messageTextView.text.isEmpty {
            messageTextView.text = currentMessage
        }
        
        let prepared = "This is the message that you can share on the Map Page to let your parents and friends know that you are safe!\n\n"
        bodyLabel.text = prepared + "Current message:\n\(currentMessage)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        messageTextView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor).isActive = true
        messageTextView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        messageTextView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.topAnchor.constraint(equalTo: messageTextView.safeAreaLayoutGuide.bottomAnchor, constant: 20).isActive = true
        bodyLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
    }
    
    private func setupMessageTextField() {
        messageTextView.isSelectable = true
        messageTextView.isScrollEnabled = false
        messageTextView.textContainer.maximumNumberOfLines = 7
        messageTextView.textContainer.lineBreakMode = .byTruncatingTail
        messageTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        messageTextView.textAlignment = .left
        messageTextView.font = UIFont.systemFont(ofSize: 18)
        messageTextView.layer.borderWidth = 0.2
        messageTextView.layer.borderColor = UIColor.separator.cgColor
        messageTextView.backgroundColor = .secondarySystemGroupedBackground
        messageTextView.autocorrectionType = UITextAutocorrectionType.default
        messageTextView.keyboardType = UIKeyboardType.default
        messageTextView.delegate = self
    }
    
    private func setupBodyLabel() {
        bodyLabel.numberOfLines = 0
        bodyLabel.textColor = .secondaryLabel
        bodyLabel.font = UIFont.systemFont(ofSize: 15)
        bodyLabel.textAlignment = .left
    }
    
}

extension MessageEditorView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textMessage = (messageTextView.text! as NSString).replacingCharacters(in: range, with: text)
        if textMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            navigationItem?.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem?.rightBarButtonItem?.isEnabled = true
        }
        let existingLines = textView.text.components(separatedBy: CharacterSet.newlines)
        let newLines = text.components(separatedBy: CharacterSet.newlines)
        let linesAfterChange = existingLines.count + newLines.count - 1

        return linesAfterChange <= textView.textContainer.maximumNumberOfLines
    }
    
    /*
    func textViewDidBeginEditing(_ textView: UITextView) {
        if messageTextView.textColor == .tertiaryLabel {
            messageTextView.text = nil
            messageTextView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if messageTextView.text.isEmpty {
            messageTextView.text = currentMessage
            messageTextView.textColor = .tertiaryLabel
        }
    }
    */
    
}
