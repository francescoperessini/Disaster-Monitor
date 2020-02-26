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
    }
}


// MARK: - View
class FilterView: UIView, ViewControllerModellableView {   //
    var mainLabel = UILabel()
    var slider = UISlider()
    var sliderLabel = UILabel()
    var sliderLabelComment = UILabel()
    
    var sortingLabel = UILabel()
    var sortingLabelComment = UILabel()
    
    var closeButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
    var didTapSlider: ((Float) -> ())?
    var didTapClose: (() -> ())?
    @objc func didTapSliderFunc(sender: UISlider){
        didTapSlider?(sender.value)
    }
    
    @objc func didTapCloseFunc(){
        didTapClose?()
    }
    
    func setup() {
        backgroundColor = .white
        self.addSubview(mainLabel)
        self.addSubview(slider)
        self.addSubview(sliderLabel)
        self.addSubview(sliderLabelComment)
        self.addSubview(sortingLabel)
        self.addSubview(sortingLabelComment)
        self.addSubview(closeButton)
        
        self.closeButton.setTitle("Apply", for: .normal)
        self.closeButton.addTarget(self, action: #selector(didTapCloseFunc), for: .touchUpInside)
        self.mainLabel.text = "Filters"
        self.sliderLabel.text = "Magnitudo"
        self.sliderLabelComment.text = "You can set here the desidered threshold"
        
        self.slider.isContinuous = false
        self.slider.maximumValue = 5
        self.slider.minimumValue = 0
        self.slider.frame = CGRect(x: 0, y: 0, width: 400, height: 35)
        self.slider.minimumTrackTintColor = .black
        self.slider.maximumTrackTintColor = .lightGray
        self.slider.thumbTintColor = .black
        
        slider.addTarget(self, action: #selector(didTapSliderFunc), for: .valueChanged)
        
        self.sortingLabel.text = "Sorting Preferences"
        self.sortingLabelComment.text = "You can set here the desidered ordering"
        
    
    }
    
    func style() {
        let h1title = UIFont(name: "Futura", size: 30)
        let h2title = UIFont(name: "Futura", size: 20)
        let h3title = UIFont(name: "Futura", size: 15)
        
        self.backgroundColor = .systemBackground
        self.mainLabel.font = h1title
        
        self.sliderLabel.font = h2title
        self.sliderLabelComment.font = h3title
        self.sliderLabelComment.textColor = .systemGray
        
        self.sortingLabel.font = h2title
        self.sortingLabelComment.font = h3title
        self.sortingLabelComment.textColor = .systemGray
        
        self.closeButton.titleLabel?.font = h2title
        self.closeButton.backgroundColor = .systemBlue
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
        
        self.sortingLabel.pin.below(of: slider).sizeToFit().marginTop(CGFloat(10)).left(30)
        self.sortingLabelComment.pin.below(of: sortingLabel).left(30).sizeToFit()
        
        self.closeButton.pin.top(0).right(0)
    
    }
    
    func close(){
        
        
    }
}
