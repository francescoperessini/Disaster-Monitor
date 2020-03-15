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
            USGSSwitch.isHidden = !filterSectionType.containsUSGSSwitch
        }
    }
    
    // MARK: - Description Label
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
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
        slider.minimumValue = 0.0
        slider.maximumValue = 6.0
        slider.addTarget(self, action: #selector(didSlideFunc), for: .valueChanged)
        return slider
    }()
    
    lazy var magnitudeSliderValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        return label
    }()
    
    var didSlide: ((Float) -> ())?
        
    @objc func didSlideFunc(sender: UISlider) {
        setSliderValue(value: sender.value)
        didSlide?(sender.value)
    }
    
    private func setSliderValue(value: Float) {
        let string = String(String(value).prefix(4))
        if string == "6.0" {
            magnitudeSliderValueLabel.text = "> " + string
        }
        else {
            magnitudeSliderValueLabel.text = string
        }
    }
    
    // MARK: - Time Period Section
    func setupTimePeriodSection(period: String) {
        timePeriodSegmentedControl.selectedSegmentIndex = ["1", "3", "5", "7"].firstIndex(of: period) ?? 0
        setPeriod(period: period)
    }
    
    lazy var timePeriodSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["1", "3", "5", "7"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(didTapSegmentedControlFunc), for: .valueChanged)
        return segmentedControl
    }()
    
    lazy var timePeriodSegmentedControlValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        return label
    }()
    
    var didTapSegmented: ((Int) -> ())?
    
    @objc func didTapSegmentedControlFunc(sender: UISegmentedControl) {
        let period = timePeriodSegmentedControl.titleForSegment(at: timePeriodSegmentedControl.selectedSegmentIndex)
        setPeriod(period: period!)
        didTapSegmented?(Int(sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "") ?? 0)
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
    func setupDataSourceSection(dic: [String: Bool]) {
        INGVSwitch.setOn(dic["INGV"]!, animated: true)
        USGSSwitch.setOn(dic["USGS"]!, animated: true)
    }
    
    lazy var INGVSwitch: UISwitch = {
        let switch1 = UISwitch()
        switch1.addTarget(self, action: #selector(didTapSwitch1Func(sender:)), for: .valueChanged)
        return switch1
    }()
    
    lazy var USGSSwitch: UISwitch = {
        let switch2 = UISwitch()
        switch2.addTarget(self, action: #selector(didTapSwitch2Func(sender:)), for: .valueChanged)
        return switch2
    }()
    
    var didTapSwitchINGV: ((Bool) -> ())?
    var didTapSwitchUSGS: ((Bool) -> ())?
    
    @objc func didTapSwitch1Func(sender: UISwitch) {
        didTapSwitchINGV?(sender.isOn)
    }
    
    @objc func didTapSwitch2Func(sender: UISwitch) {
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
        addSubview(USGSSwitch)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        //descriptionLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        //descriptionLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        magnitudoSlider.translatesAutoresizingMaskIntoConstraints = false
        magnitudoSlider.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        magnitudoSlider.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        magnitudoSlider.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        magnitudoSlider.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        magnitudeSliderValueLabel.translatesAutoresizingMaskIntoConstraints = false
        //magnitudeSliderValueLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        magnitudeSliderValueLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        magnitudeSliderValueLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        //magnitudeSliderValueLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
                
        timePeriodSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        timePeriodSegmentedControl.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        timePeriodSegmentedControl.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        timePeriodSegmentedControl.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        timePeriodSegmentedControl.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        timePeriodSegmentedControlValueLabel.translatesAutoresizingMaskIntoConstraints = false
        //timePeriodSegmentedControlValueLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        timePeriodSegmentedControlValueLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        timePeriodSegmentedControlValueLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        //timePeriodSegmentedControlValueLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        INGVSwitch.translatesAutoresizingMaskIntoConstraints = false
        //INGVSwitch.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        INGVSwitch.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        INGVSwitch.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        //INGVSwitch.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        USGSSwitch.translatesAutoresizingMaskIntoConstraints = false
        //USGSSwitch.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        USGSSwitch.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        USGSSwitch.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        //USGSSwitch.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

}
