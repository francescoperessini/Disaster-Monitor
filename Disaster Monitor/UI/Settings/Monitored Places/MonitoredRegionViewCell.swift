//
//  MonitoredRegionViewCell.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 20/03/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura

class MonitoredRegionViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(nameLabel)
        addSubview(coordinatesLabel)
    }
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.textColor = .label
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var coordinatesLabel: UILabel = {
        let coordinatesLabel = UILabel()
        coordinatesLabel.font = UIFont.systemFont(ofSize: 15)
        coordinatesLabel.textColor = .secondaryLabel
        coordinatesLabel.textAlignment = .left
        return coordinatesLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 9).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        
        coordinatesLabel.translatesAutoresizingMaskIntoConstraints = false
        coordinatesLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -9).isActive = true
        coordinatesLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        coordinatesLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
    }
    
    func setupCell(place: Region) {
        self.nameLabel.text = "\(place.name) • Magnitude: \(place.magnitude) • Distance: \(place.distance) km"
        self.coordinatesLabel.text = String(format:"Latitude: %.4f • Longitudine: %.4f", place.latitude, place.longitudine)
    }
    
}
