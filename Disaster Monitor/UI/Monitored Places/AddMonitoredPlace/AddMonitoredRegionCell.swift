//
//  AddMonitoredRegionCell.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 21/03/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura
import GooglePlaces
import GoogleMaps

class AddMonitoredRegionCell: UITableViewCell {
    // MARK: - Properties
    var sectionType: SectionTypeAddMonitored? {
        didSet {
            guard let sectionType = sectionType else { return }
            textLabel?.text = sectionType.description
            
            stepperControlRadius.isHidden = !sectionType.containsStepperMagnitudo
            stepperControlMagnitudo.isHidden = !sectionType.containsStepperRadius
            mapView.isHidden = !sectionType.containsMap
        }
    }
    
    lazy var stepperControlRadius: UIStepper = {
        let switchControl = UIStepper()
        switchControl.autorepeat = false
        switchControl.minimumValue = 0
        switchControl.maximumValue = 1000
        switchControl.stepValue = 100
        //switchControl.addTarget(self, action: #selector(handleTapRadius), for: .valueChanged)
        return switchControl
    }()
    
    lazy var stepperControlMagnitudo: UIStepper = {
        let switchControl = UIStepper()
        switchControl.autorepeat = false
        switchControl.minimumValue = 0
        switchControl.maximumValue = 1000
        switchControl.stepValue = 100
        //switchControl.addTarget(self, action: #selector(handleTapRadius), for: .valueChanged)
        return switchControl
    }()
    
    
    lazy var mapView: GMSMapView = {
       let mapView = GMSMapView()
        return mapView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(stepperControlRadius)
        self.addSubview(stepperControlMagnitudo)
        self.addSubview(mapView)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        stepperControlRadius.translatesAutoresizingMaskIntoConstraints = false
        stepperControlRadius.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        stepperControlRadius.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        
        stepperControlMagnitudo.translatesAutoresizingMaskIntoConstraints = false
        stepperControlMagnitudo.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        stepperControlMagnitudo.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
    }
    
    
}

