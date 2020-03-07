//
//  MainEventsTableViewCell.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 28/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura

class MainEventsTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
        self.style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Subviews
    var nameLabel = UILabel()
    var descriptionLabel = UILabel()
    var magnitudoLabel = UILabel()
    
    // MARK: Setup
    func setup() {
        self.addSubview(nameLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(magnitudoLabel)
    }
    
    // MARK: Style
    func style() {
        self.backgroundColor = .systemBackground
        nameLabelStyle()
        descriptionLabelStyle()
        magnitudoLabelStyle()
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        magnitudoLabel.translatesAutoresizingMaskIntoConstraints = false
        magnitudoLabel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        magnitudoLabel.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        magnitudoLabel.heightAnchor.constraint(equalToConstant: self.bounds.height).isActive = true
    
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 2.5).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: magnitudoLabel.safeAreaLayoutGuide.rightAnchor, constant: -50).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: self.bounds.height / 2).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -2.5).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        descriptionLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: self.bounds.height / 2).isActive = true
    }
    
    func setupCell(event: Event) {
        nameLabel.text = event.name
        descriptionLabel.text = event.description
        magnitudoLabel.text = String(event.magnitudo)
        
        // Dangerous are those with magnitude over 3 --> they are blue
        if event.magnitudo > 3 {
            magnitudoLabel.textColor = .systemBlue
        }
        else {
            magnitudoLabel.textColor = .systemGray
        }
    }
    
    private func nameLabelStyle() {
        //nameLabel.font = UIFont(name: "Futura", size: 18)
        nameLabel.font = UIFont.systemFont(ofSize: 18)
    }
    
    private func descriptionLabelStyle() {
        //descriptionLabel.font = UIFont(name: "Futura", size: 15)
        descriptionLabel.font = UIFont.systemFont(ofSize: 15)
        descriptionLabel.textColor = .systemGray
    }
    
    private func magnitudoLabelStyle() {
        //magnitudoLabel.font = UIFont(name: "Futura", size: 22)
        magnitudoLabel.font = UIFont.boldSystemFont(ofSize: 22)
    }
    
}
