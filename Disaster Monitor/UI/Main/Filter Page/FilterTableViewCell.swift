//
//  FilterTableViewCell.swift
//  Disaster Monitor
//
//  Created by Francesco Peressini on 13/03/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura

class FilterTableViewCell: UITableViewCell {
    
    var filterSectionType: FilterSectionType? {
        didSet {
            guard let filterSectionType = filterSectionType else { return }
            descriptionLabel.isHidden = !filterSectionType.containsDescriptionLabel
            if(!descriptionLabel.isHidden) {
                descriptionLabel.text = filterSectionType.description
            }
            
            magnitudoSlider.isHidden = !filterSectionType.containsMagnitudeSlider
            magnitudeSliderValueLabel.isHidden = !filterSectionType.containsMagnitudeSliderValueLabel
            
            timePeriodSegmentedControl.isHidden = !filterSectionType.containsTimePeriodSegmentedControl
            timePeriodSegmentedControlValueLabel.isHidden = !filterSectionType.containsTimePeriodSegmentedControlValueLabel
            
            INGVSwitch.isHidden = !filterSectionType.containsINGVSwitch
            INGVdescriptionLabel.isHidden = !filterSectionType.containsINGVdescriptionLabel
            INGVdescriptionLabel.text = filterSectionType.description
            
            USGSSwitch.isHidden = !filterSectionType.containsUSGSSwitch
            USGSdescriptionLabel.isHidden = !filterSectionType.containsUSGSdescriptionLabel
            USGSdescriptionLabel.text = filterSectionType.description
        }
    }
    
    // MARK: - Description Label
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    // MARK: - Magnitude Section
    func setupMagnitudeSection(value: Float) {
        magnitudoSlider.setValue(value, animated: true)
        setSliderValue(value: value)
    }
    
    lazy var magnitudoSlider: UISlider = {
        let slider = UISlider()
        slider.isContinuous = false
        slider.minimumValue = -1.0
        slider.maximumValue = 10.0
        slider.addTarget(self, action: #selector(didSlideFuncLabel), for: .touchDragInside)
        slider.addTarget(self, action: #selector(didSlideFuncState), for: .valueChanged)
        return slider
    }()
    
    lazy var magnitudeSliderValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    var didSlide: ((Float) -> ())?
    
    @objc func didSlideFuncLabel(sender: UISlider) {
        setSliderValue(value: sender.value)
    }
    
    @objc func didSlideFuncState(sender: UISlider) {
        didSlide?(sender.value)
    }
    
    private func setSliderValue(value: Float) {
        let string: String
        if value < 0 {
            string = String(String(value).prefix(5))
        }
        else {
            string = String(String(value).prefix(4))
        }
        magnitudeSliderValueLabel.text = ">= " + string
    }
    
    // MARK: - Time Period Section
    func setupTimePeriodSection(period: String) {
        let index = ["1", "3", "5", "7"].firstIndex(of: period) ?? 3
        timePeriodSegmentedControl.selectedSegmentIndex = index
        setPeriod(period: period)
    }
    
    lazy var timePeriodSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["1", "3", "5", "7"])
        segmentedControl.addTarget(self, action: #selector(didTapSegmentedControlFunc), for: .valueChanged)
        return segmentedControl
    }()
    
    lazy var timePeriodSegmentedControlValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    var didTapSegmented: ((Int) -> ())?
    
    @objc func didTapSegmentedControlFunc(sender: UISegmentedControl) {
        let period = timePeriodSegmentedControl.titleForSegment(at: timePeriodSegmentedControl.selectedSegmentIndex)!
        setPeriod(period: period)
        didTapSegmented?(Int(period)!)
    }
    
    private func setPeriod(period: String) {
        if period == "1" {
            timePeriodSegmentedControlValueLabel.text = period + " day"
        }
        else {
            timePeriodSegmentedControlValueLabel.text = period + " days"
        }
    }
    
    // MARK: - Data Source Section
    func setupINGVSwitch(value: Bool) {
        INGVSwitch.setOn(value, animated: true)
    }
    
    func setupUSGSSwitch(value: Bool) {
        USGSSwitch.setOn(value, animated: true)
    }
    
    lazy var INGVSwitch: UISwitch = {
        let switch1 = UISwitch()
        switch1.addTarget(self, action: #selector(didTapSwitchINGVFunc), for: .valueChanged)
        return switch1
    }()
    
    lazy var USGSSwitch: UISwitch = {
        let switch2 = UISwitch()
        switch2.addTarget(self, action: #selector(didTapSwitchUSGSFunc), for: .valueChanged)
        return switch2
    }()
    
    lazy var INGVdescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    lazy var USGSdescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    var didTapSwitchINGV: ((Bool) -> ())?
    var didTapSwitchUSGS: ((Bool) -> ())?
    
    @objc func didTapSwitchINGVFunc(sender: UISwitch) {
        didTapSwitchINGV?(sender.isOn)
    }
    
    @objc func didTapSwitchUSGSFunc(sender: UISwitch) {
        didTapSwitchUSGS?(sender.isOn)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }
    
    private func setup() {
        addSubview(descriptionLabel)
        addSubview(magnitudoSlider)
        addSubview(magnitudeSliderValueLabel)
        addSubview(timePeriodSegmentedControl)
        addSubview(timePeriodSegmentedControlValueLabel)
        addSubview(INGVSwitch)
        addSubview(INGVdescriptionLabel)
        addSubview(USGSSwitch)
        addSubview(USGSdescriptionLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        
        magnitudeSliderValueLabel.translatesAutoresizingMaskIntoConstraints = false
        magnitudeSliderValueLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        magnitudeSliderValueLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        
        timePeriodSegmentedControlValueLabel.translatesAutoresizingMaskIntoConstraints = false
        timePeriodSegmentedControlValueLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        timePeriodSegmentedControlValueLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        
        magnitudoSlider.translatesAutoresizingMaskIntoConstraints = false
        magnitudoSlider.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        magnitudoSlider.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        magnitudoSlider.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        
        timePeriodSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        timePeriodSegmentedControl.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        timePeriodSegmentedControl.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        timePeriodSegmentedControl.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        
        INGVdescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        INGVdescriptionLabel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        INGVdescriptionLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        
        INGVSwitch.translatesAutoresizingMaskIntoConstraints = false
        INGVSwitch.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        INGVSwitch.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        
        USGSdescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        USGSdescriptionLabel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        USGSdescriptionLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        
        USGSSwitch.translatesAutoresizingMaskIntoConstraints = false
        USGSSwitch.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        USGSSwitch.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
    }
    
}
