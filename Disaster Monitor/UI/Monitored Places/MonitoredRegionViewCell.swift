//
//  MonitoredRegionViewCell.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 20/03/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura

class MonitoredRegionViewCell: UITableViewCell {
    
    // MARK: - Description Label
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        return nameLabel
    }()
    
    lazy var coordinatesLabel: UILabel = {
        let coordinatesLabel = UILabel()
        return coordinatesLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    private func setup() {
        addSubview(nameLabel)
        addSubview(coordinatesLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 9).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        
        coordinatesLabel.translatesAutoresizingMaskIntoConstraints = false
        coordinatesLabel.topAnchor.constraint(equalTo: nameLabel.safeAreaLayoutGuide.bottomAnchor, constant: 5).isActive = true
        coordinatesLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        
        coordinatesLabel.textColor = .systemGray
    }
    
    func setupCell(region: Region) {
        self.nameLabel.text = "\(region.name) • magnitudo: \(region.magnitude) • radius: \(region.radius)"
        self.coordinatesLabel.text = "\(region.latitude) • \(region.longitudine)"
    }
    
}
