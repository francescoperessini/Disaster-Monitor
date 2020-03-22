//
//  MainEventsTableViewCell.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 28/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import UIKit

class MainEventsTableViewCell: UITableViewCell {
    
    var placeLabel = UILabel()
    let stackView = UIStackView()
    var timeLabel = UILabel()
    let separatorLabel1 = UILabel()
    var seismicTypeLabel = UILabel()
    let separatorLabel2 = UILabel()
    var dataSourceLabel = UILabel()
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
        stackView.addArrangedSubview(separatorLabel1)
        stackView.addArrangedSubview(seismicTypeLabel)
        stackView.addArrangedSubview(separatorLabel2)
        stackView.addArrangedSubview(dataSourceLabel)
    }
    
    private func style() {
        backgroundColor = .systemBackground
        placeLabelStyle()
        separatorStyle()
        timeLabelStyle()
        seismicTypeLabelStyle()
        magnitudoLabelStyle()
        dataSourceLabelStyle()
    }
    
    private func placeLabelStyle() {
        placeLabel.font = UIFont.systemFont(ofSize: 18)
    }
    
    private func timeLabelStyle() {
        timeLabel.font = UIFont.systemFont(ofSize: 15)
        timeLabel.textColor = .systemGray
    }
    
    private func separatorStyle() {
        separatorLabel1.font = UIFont.systemFont(ofSize: 15)
        separatorLabel1.text = "•"
        separatorLabel1.textColor = .systemGray
        
        separatorLabel2.font = UIFont.systemFont(ofSize: 15)
        separatorLabel2.text = "•"
        separatorLabel2.textColor = .systemGray
    }
    
    private func seismicTypeLabelStyle() {
        seismicTypeLabel.font = UIFont.systemFont(ofSize: 15)
        seismicTypeLabel.textColor = .systemGray
    }
    
    private func magnitudoLabelStyle() {
        magnitudoLabel.font = UIFont.boldSystemFont(ofSize: 22)
    }
    
    private func dataSourceLabelStyle() {
        dataSourceLabel.font = UIFont.systemFont(ofSize: 15)
        dataSourceLabel.textColor = .systemGray
    }
    
    func setupCell(event: Event, color: Color) {
        placeLabel.text = event.name
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "HH:mm"
        let formattedDate = formatter.string(from: event.date)
        timeLabel.text = formattedDate + " UTC"
        
        seismicTypeLabel.text = event.description
        
        magnitudoLabel.text = String(event.magnitudo)
        
        dataSourceLabel.text = event.dataSource

        if event.magnitudo > 3 {
            magnitudoLabel.textColor = color.getColor()
        }
        else {
            magnitudoLabel.textColor = .systemGray
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        placeLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 9).isActive = true
        placeLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        placeLabel.trailingAnchor.constraint(equalTo: magnitudoLabel.safeAreaLayoutGuide.trailingAnchor, constant: -60).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -11).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
                
        magnitudoLabel.translatesAutoresizingMaskIntoConstraints = false
        magnitudoLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 7).isActive = true
        magnitudoLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -7).isActive = true
        magnitudoLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -7).isActive = true
    }
    
}
