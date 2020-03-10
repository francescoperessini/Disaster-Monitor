//
//  MainEventsTableViewCell.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 28/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura

class MainEventsTableViewCell: UITableViewCell {
    
    var placeLabel = UILabel()
    let stackView = UIStackView()
    var timeLabel = UILabel()
    let separatorLabel = UILabel()
    var seismicTypeLabel = UILabel()
    var magnitudoLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
        self.style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(placeLabel)
        addSubview(magnitudoLabel)
        addSubview(stackView)
        setupStackView()
    }
    
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 5.0
        
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(separatorLabel)
        stackView.addArrangedSubview(seismicTypeLabel)
    }
    
    private func style() {
        backgroundColor = .systemBackground
        placeLabelStyle()
        timeLabelStyle()
        separatorStyle()
        seismicTypeLabelStyle()
        magnitudoLabelStyle()
    }
    
    private func placeLabelStyle() {
        //placeLabel.font = UIFont(name: "Futura", size: 18)
        placeLabel.font = UIFont.systemFont(ofSize: 18)
    }
    
    private func timeLabelStyle() {
        //timeLabel.font = UIFont(name: "Futura", size: 15)
        timeLabel.font = UIFont.systemFont(ofSize: 15)
        timeLabel.textColor = .systemGray
    }
    
    private func separatorStyle() {
        //separatorLabel.font = UIFont(name: "Futura", size: 15)
        separatorLabel.font = UIFont.systemFont(ofSize: 15)
        separatorLabel.text = "•"
        separatorLabel.textColor = .systemGray
    }
    
    private func seismicTypeLabelStyle() {
        //seismicTypeLabel.font = UIFont(name: "Futura", size: 15)
        seismicTypeLabel.font = UIFont.systemFont(ofSize: 15)
        seismicTypeLabel.textColor = .systemGray
    }
    
    private func magnitudoLabelStyle() {
        //magnitudoLabel.font = UIFont(name: "Futura", size: 22)
        magnitudoLabel.font = UIFont.boldSystemFont(ofSize: 22)
    }
    
    func setupCell(event: Event) {
        placeLabel.text = event.name
        
        let date = Date(timeIntervalSince1970: event.time / 1000)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "HH:mm"
        timeLabel.text = formatter.string(from: date as Date) + " UTC"
        
        seismicTypeLabel.text = event.description
        
        magnitudoLabel.text = String(event.magnitudo)

        if event.magnitudo > 3 {
            magnitudoLabel.textColor = .systemBlue
        }
        else {
            magnitudoLabel.textColor = .systemGray
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        placeLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 7).isActive = true
        placeLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        placeLabel.trailingAnchor.constraint(equalTo: magnitudoLabel.safeAreaLayoutGuide.trailingAnchor, constant: -50).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -7).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
                
        magnitudoLabel.translatesAutoresizingMaskIntoConstraints = false
        magnitudoLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 7).isActive = true
        magnitudoLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -7).isActive = true
        magnitudoLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -7).isActive = true
    }
    
}
