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
            
            stepperControlRadius.isHidden = !sectionType.containsStepperRadius
            stepperControlMagnitudo.isHidden = !sectionType.containsStepperMagnitudo
            mapView.isHidden = !sectionType.containsMap
            nameTextField.isHidden = !sectionType.containsNameTextField
            stepperControlMagnitudoLabel.isHidden = !sectionType.containsStepperMagnitudo
            stepperControlRadiusLabel.isHidden = !sectionType.containsStepperRadius
        }
    }
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    lazy var stepperControlRadius: UIStepper = {
        let switchControl = UIStepper()
        switchControl.autorepeat = false
        switchControl.minimumValue = 0
        switchControl.maximumValue = 1000
        switchControl.stepValue = 100
        switchControl.value = 300
        switchControl.addTarget(self, action: #selector(handleTapRadius), for: .valueChanged)
        return switchControl
    }()
    
    lazy var stepperControlRadiusLabel: UILabel = {
        let label = UILabel()
        label.text = "\(self.stepperControlRadius.value)"
        return label
    }()
    
    lazy var stepperControlMagnitudo: UIStepper = {
        let switchControl = UIStepper()
        switchControl.autorepeat = false
        switchControl.minimumValue = -1
        switchControl.maximumValue = 9
        switchControl.stepValue = 0.5
        switchControl.value = 3
        switchControl.addTarget(self, action: #selector(handleTapMagnitudo), for: .valueChanged)
        return switchControl
    }()
    
    lazy var stepperControlMagnitudoLabel: UILabel = {
        let label = UILabel()
        label.text = "\(self.stepperControlMagnitudo.value)"
        return label
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
        self.addSubview(nameTextField)
        self.addSubview(stepperControlMagnitudoLabel)
        self.addSubview(stepperControlRadiusLabel)
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
        
            stepperControlRadiusLabel.translatesAutoresizingMaskIntoConstraints = false
            stepperControlRadiusLabel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
            stepperControlRadiusLabel.rightAnchor.constraint(equalTo: self.stepperControlRadius.leftAnchor, constant: -10).isActive = true
        
        stepperControlMagnitudo.translatesAutoresizingMaskIntoConstraints = false
        stepperControlMagnitudo.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        stepperControlMagnitudo.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
            
            stepperControlMagnitudoLabel.translatesAutoresizingMaskIntoConstraints = false
            stepperControlMagnitudoLabel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
            stepperControlMagnitudoLabel.rightAnchor.constraint(equalTo: self.stepperControlMagnitudo.leftAnchor, constant: -10).isActive = true
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        
        /*stepperLabelMagnitudo.translatesAutoresizingMaskIntoConstraints = false
        stepperLabelMagnitudo.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        stepperLabelMagnitudo.rightAnchor.constraint(equalTo: stepperControlMagnitudo.rightAnchor, constant: -130).isActive = true*/
        
        
    }
    
    @objc func handleTapMagnitudo(sender: UIStepper){
        print(sender.value)
        self.stepperControlMagnitudoLabel.text = "\(sender.value)"
    }
    
    @objc func handleTapRadius(sender: UIStepper){
        print(sender.value)
        self.stepperControlRadiusLabel.text = "\(sender.value)"
    }
}

