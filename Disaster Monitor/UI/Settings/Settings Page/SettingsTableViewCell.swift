//
//  SettingsTableViewCell.swift
//  Disaster Monitor
//
//  Created by Francesco Peressini on 26/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import UIKit
import PinLayout

class SettingsTableViewCell: UITableViewCell {
    // MARK: - Properties
    var sectionType: SectionType?{
        didSet{
            guard let sectionType = sectionType else { return }
            textLabel?.text = sectionType.description
            stepperControlMagnitudo.isHidden = !sectionType.containsStepperMagnitudo
            stepperLabelMagnitudo.isHidden = !sectionType.containsStepperMagnitudo
            
            stepperControlRadius.isHidden = !sectionType.containsStepperRadius
            stepperLabelRadius.isHidden = !sectionType.containsStepperRadius
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
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        super.addSubview(stepperLabelMagnitudo)
        self.addSubview(stepperControlMagnitudo)
        self.stepperControlMagnitudo.pin.right(-70).vCenter()
        self.stepperLabelMagnitudo.pin.left(of: stepperControlMagnitudo).sizeToFit().marginRight(50).top(15)
        
        super.addSubview(stepperLabelRadius)
        self.addSubview(stepperControlRadius)
        self.stepperControlRadius.pin.right(-70).vCenter()
        self.stepperLabelRadius.pin.left(of: stepperControlMagnitudo).sizeToFit().marginRight(50).top(15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func handleTapMagnitudo(sender: UIStepper){
        self.stepperLabelMagnitudo.text = String(sender.value)
    }
    
    @objc func handleTapRadius(sender: UIStepper){
        self.stepperLabelRadius.text = String(sender.value)
    }
}

