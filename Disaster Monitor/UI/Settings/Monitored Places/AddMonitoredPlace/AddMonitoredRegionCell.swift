//
//  AddMonitoredRegionCell.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 21/03/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura
import GoogleMaps

class AddMonitoredRegionCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(nameTextField)
        addSubview(stepperControlMagnitude)
        addSubview(stepperControlMagnitudeLabel)
        addSubview(stepperControlDistance)
        addSubview(stepperControlDistanceLabel)
        addSubview(mapView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var sectionType: SectionTypeAddMonitored? {
        didSet {
            guard let sectionType = sectionType else { return }
            textLabel?.text = sectionType.description
            
            nameTextField.isHidden = !sectionType.containsNameTextField
            stepperControlMagnitude.isHidden = !sectionType.containsStepperMagnitude
            stepperControlMagnitudeLabel.isHidden = !sectionType.containsStepperMagnitude
            stepperControlDistance.isHidden = !sectionType.containsStepperDistance
            stepperControlDistanceLabel.isHidden = !sectionType.containsStepperDistance
            mapView.isHidden = !sectionType.containsMap
        }
    }
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type here..."
        textField.textColor = .label
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.layer.borderWidth = 0.0
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.backgroundColor = .clear
        textField.autocorrectionType = UITextAutocorrectionType.yes
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.enablesReturnKeyAutomatically = true
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        return textField
    }()
    
    lazy var stepperControlMagnitude: UIStepper = {
        let stepper = UIStepper()
        stepper.autorepeat = false
        stepper.minimumValue = -1.0
        stepper.maximumValue = 10.0
        stepper.stepValue = 0.5
        stepper.value = -1.0
        stepper.addTarget(self, action: #selector(handleTapStepperControlMagnitude), for: .valueChanged)
        return stepper
    }()
    
    lazy var stepperControlMagnitudeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = ">= \(stepperControlMagnitude.value)"
        return label
    }()
    
    @objc func handleTapStepperControlMagnitude(sender: UIStepper) {
        stepperControlMagnitudeLabel.text = ">= \(sender.value)"
    }
    
    lazy var stepperControlDistance: UIStepper = {
        let stepper = UIStepper()
        stepper.autorepeat = false
        stepper.minimumValue = 0.5
        stepper.maximumValue = 10.0
        stepper.stepValue = 0.5
        stepper.value = 0.5
        stepper.addTarget(self, action: #selector(handleTapStepperControlDistance), for: .valueChanged)
        return stepper
    }()
    
    lazy var stepperControlDistanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = "\(stepperControlDistance.value) km"
        return label
    }()
    
    @objc func handleTapStepperControlDistance(sender: UIStepper){
        stepperControlDistanceLabel.text = "\(sender.value) km"
    }
    
    lazy var mapView: GMSMapView = {
        let mapView = GMSMapView()
        return mapView
    }()
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let mapStyleString: String
        
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            mapStyleString = "light_map_style"
        case .dark:
            mapStyleString = "dark_map_style"
        default:
            mapStyleString = "light_map_style"
        }
        
        mapStyleByURL(mapStyleString: mapStyleString)
    }
    
    func mapStyleByURL(mapStyleString: String) {
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: mapStyleString, withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        nameTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        stepperControlMagnitude.translatesAutoresizingMaskIntoConstraints = false
        stepperControlMagnitude.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        stepperControlMagnitude.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        
        stepperControlMagnitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        stepperControlMagnitudeLabel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        stepperControlMagnitudeLabel.trailingAnchor.constraint(equalTo: stepperControlMagnitude.leadingAnchor, constant: -5).isActive = true
        
        stepperControlDistance.translatesAutoresizingMaskIntoConstraints = false
        stepperControlDistance.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        stepperControlDistance.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        
        stepperControlDistanceLabel.translatesAutoresizingMaskIntoConstraints = false
        stepperControlDistanceLabel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        stepperControlDistanceLabel.trailingAnchor.constraint(equalTo: stepperControlDistance.leadingAnchor, constant: -5).isActive = true
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
}
