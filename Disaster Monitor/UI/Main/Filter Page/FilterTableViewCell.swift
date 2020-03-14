//
//  FilterTableViewCell.swift
//  Disaster Monitor
//
//  Created by Francesco Peressini on 13/03/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura

protocol YourCellDelegate: class {
    func didSlideFuncController(_ value: Float)
}

class FilterTableViewCell: UITableViewCell {
    
    var cellDelegate: YourCellDelegate?
    
    var filterSectionType: FilterSectionType? {
        didSet {
            guard let filterSectionType = filterSectionType else { return }
            descriptionLabel.isHidden = !filterSectionType.containsDescriptionLabel
            if(!descriptionLabel.isHidden) {
                descriptionLabel.text = filterSectionType.description
            }
            
            magnitudoSlider.isHidden = !filterSectionType.containsMagnitudeSlider
            magnitudeSliderValueLabel.isHidden = !filterSectionType.containsMagnitudeSliderValueLabel
            if(!magnitudeSliderValueLabel.isHidden) {
                print("da mettere valore dello stato!")
            }
            
            timePeriodSegmentedControl.isHidden = !filterSectionType.containsTimePeriodSegmentedControl
            timePeriodSegmentedControlValueLabel.isHidden = !filterSectionType.containsTimePeriodSegmentedControlValueLabel
            if(!timePeriodSegmentedControlValueLabel.isHidden) {
                print("da mettere valore dello stato!")
            }
        }
    }
    
    // MARK: - Description Label
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    // MARK: - Slider
    lazy var magnitudoSlider: UISlider = {
        let slider = UISlider()
        slider.isContinuous = false
        slider.minimumValue = 0
        slider.maximumValue = 6
        slider.addTarget(self, action: #selector(didSlideFunc), for: .valueChanged)
        return slider
    }()
    
    lazy var magnitudeSliderValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        return label
    }()
        
    @objc func didSlideFunc(sender: UISlider) {
        magnitudeSliderValueLabel.text = String(sender.value)
        cellDelegate?.didSlideFuncController(sender.value)
    }
    
    // MARK: - Segmented Control
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
        if period == "1" {
            timePeriodSegmentedControlValueLabel.text = period! + " day"
        }
        else {
            timePeriodSegmentedControlValueLabel.text = period! + " days"
        }
        didTapSegmented?(Int(sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "") ?? 0)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    private func setup() {
        addSubview(descriptionLabel)
        addSubview(magnitudoSlider)
        addSubview(magnitudeSliderValueLabel)
        addSubview(timePeriodSegmentedControl)
        addSubview(timePeriodSegmentedControlValueLabel)
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
    }

}
