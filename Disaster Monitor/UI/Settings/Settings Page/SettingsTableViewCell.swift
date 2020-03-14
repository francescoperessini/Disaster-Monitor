//
//  SettingsTableViewCell.swift
//  Disaster Monitor
//
//  Created by Francesco Peressini on 26/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import UIKit
import Tempura


class SettingsTableViewCell: UITableViewCell {
    
    var didTapStylingColor: ((Color) -> ())?
    // MARK: - Properties
    var sectionType: SectionType?{
        didSet{
            guard let sectionType = sectionType else { return }
            textLabel?.text = sectionType.description
            stepperControlMagnitudo.isHidden = !sectionType.containsStepperMagnitudo
            stepperLabelMagnitudo.isHidden = !sectionType.containsStepperMagnitudo
            
            stepperControlRadius.isHidden = !sectionType.containsStepperRadius
            stepperLabelRadius.isHidden = !sectionType.containsStepperRadius
            
            segmentedColors.isHidden = !sectionType.containsSegmenteColor
            
            segmentedMap.isHidden = !sectionType.containsSegmentedMap
        }
    }
    
    lazy var stepperControlMagnitudo: UIStepper = {
        let switchControl = UIStepper()
        switchControl.autorepeat = false
        switchControl.minimumValue = 0
        switchControl.maximumValue = 7
        switchControl.stepValue = 1
        switchControl.addTarget(self, action: #selector(handleTapMagnitudo), for: .valueChanged)
        return switchControl
    }()
    
    lazy var stepperLabelMagnitudo: UILabel = {
        let switchLabel = UILabel()
        switchLabel.text = "0"
        return switchLabel
    }()
    
    lazy var stepperControlRadius: UIStepper = {
        let switchControl = UIStepper()
        switchControl.autorepeat = false
        switchControl.minimumValue = 0
        switchControl.maximumValue = 1000
        switchControl.stepValue = 100
        switchControl.addTarget(self, action: #selector(handleTapRadius), for: .valueChanged)
        return switchControl
    }()
    
    lazy var stepperLabelRadius: UILabel = {
        let switchLabel = UILabel()
        switchLabel.text = "0"
        return switchLabel
    }()
    
    lazy var segmentedColors: UISegmentedControl = {
        let colorSegmented = UISegmentedControl(items: ["BLUE", "GREEN", "RED"])
        /*(colorSegmented.subviews[0] as UIView).tintColor = UIColor.blue
        (colorSegmented.subviews[1] as UIView).tintColor = UIColor.systemGreen
        (colorSegmented.subviews[2] as UIView).tintColor = UIColor.systemRed*/
        colorSegmented.addTarget(self, action: #selector(handleTapStylingColor), for: .valueChanged)

        return colorSegmented
    }()
    
    lazy var segmentedMap: UISegmentedControl = {
        let mapSegmented = UISegmentedControl(items: ["Standard", "Silver", "Retro", "Dark"])
        return mapSegmented
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stepperControlRadius.translatesAutoresizingMaskIntoConstraints = false
        stepperControlRadius.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        stepperControlRadius.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        
        stepperLabelRadius.translatesAutoresizingMaskIntoConstraints = false
        stepperLabelRadius.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        stepperLabelRadius.rightAnchor.constraint(equalTo: stepperControlRadius.rightAnchor, constant: -130).isActive = true
        
        stepperControlMagnitudo.translatesAutoresizingMaskIntoConstraints = false
        stepperControlMagnitudo.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        stepperControlMagnitudo.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        
        stepperLabelMagnitudo.translatesAutoresizingMaskIntoConstraints = false
        stepperLabelMagnitudo.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        stepperLabelMagnitudo.rightAnchor.constraint(equalTo: stepperControlMagnitudo.rightAnchor, constant: -130).isActive = true
        
        segmentedColors.translatesAutoresizingMaskIntoConstraints = false
        segmentedColors.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        segmentedColors.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        
        segmentedMap.translatesAutoresizingMaskIntoConstraints = false
        segmentedMap.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        segmentedMap.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        super.addSubview(stepperLabelMagnitudo)
        self.addSubview(stepperControlMagnitudo)
        
        super.addSubview(stepperLabelRadius)
        self.addSubview(stepperControlRadius)
        
        self.addSubview(segmentedColors)
        
        self.addSubview(segmentedMap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - StateInitializer
    func setupColorCell(color: Color){
        self.segmentedColors.selectedSegmentIndex = ["BLUE", "GREEN", "RED"].firstIndex(of: color.getColorName()) ?? 0
    }
    
    // MARK: - Selectors
    @objc func handleTapMagnitudo(sender: UIStepper){
        self.stepperLabelMagnitudo.text = String(sender.value)
    }
    
    @objc func handleTapRadius(sender: UIStepper){
        self.stepperLabelRadius.text = String("\(sender.value) m.")
    }
    
    @objc func handleTapStylingColor(sender: UISegmentedControl){
        print("--> \(sender.titleForSegment(at: sender.selectedSegmentIndex)!)")
        let selectedColor = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        switch selectedColor {
            case "RED": didTapStylingColor?(Color(name: colors.red))
            case "GREEN": didTapStylingColor?(Color(name: colors.green))
            default: didTapStylingColor?(Color(name: colors.blue))
        }
        
    }

}
