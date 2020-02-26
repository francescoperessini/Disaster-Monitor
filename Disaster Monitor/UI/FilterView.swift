//
//  FilterView.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 25/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Foundation
import Katana
import Tempura
import PinLayout

// MARK: - ViewModel
struct FilterViewModel: ViewModelWithState {
    var state: AppState
    init?(state: AppState) {
        self.state = state
        print(self.state)
    }
}


// MARK: - View
class FilterView: UIView, ViewControllerModellableView {   //
    var mainLabel = UILabel()
    var slider = UISlider()
    var sliderLabel = UILabel()
    var sliderLabelComment = UILabel()
    
    var didTapSlider: ((Float) -> ())?
    
    @objc func didTapSliderFunc(sender: UISlider){
        didTapSlider?(sender.value)
    }
    
    func setup() {
        backgroundColor = .white
        self.addSubview(mainLabel)
        self.addSubview(slider)
        self.addSubview(sliderLabel)
        self.addSubview(sliderLabelComment)
        
        self.mainLabel.text = "Filters"
        self.sliderLabel.text = "Magnitudo"
        self.sliderLabelComment.text = "You can set here the desidered threshold"
        self.slider.isContinuous = false
        self.slider.maximumValue = 5
        self.slider.minimumValue = 0
        self.slider.frame = CGRect(x: 0, y: 0, width: 1, height: 35)
        
        self.slider.minimumTrackTintColor = .black
        self.slider.maximumTrackTintColor = .lightGray
        self.slider.thumbTintColor = .black
        
        slider.addTarget(self, action: #selector(didTapSliderFunc), for: .valueChanged)
    
    }
    
    func style() {
        self.backgroundColor = .systemBackground
        self.mainLabel.font = UIFont(name: "Futura", size: 30)
        self.sliderLabel.font = UIFont(name: "Futura", size: 20)
    }

    func update(oldModel: FilterViewModel?) {
        guard let model = self.model else {return}

        self.slider.setValue(model.state.filteringValue, animated: true)
        self.setNeedsLayout()
    }

    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
        self.mainLabel.pin.top(20).left(20).sizeToFit()
        self.sliderLabel.pin.below(of: mainLabel).sizeToFit().marginTop(CGFloat(10)).left(30)
        self.sliderLabelComment.pin.below(of: sliderLabel).left(30).sizeToFit()
        self.slider.pin.below(of: sliderLabelComment).right(30).left(30).marginTop(10)
    }
}
