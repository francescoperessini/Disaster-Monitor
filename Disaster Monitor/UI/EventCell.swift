//
//  AttractionCell.swift
//  SmartTourist
//
//  Created on 30/11/2019
//

import Foundation
import UIKit
import Tempura
import PinLayout
import DeepDiff
import GooglePlaces
import GoogleMaps

public protocol SizeableCell: ModellableView {
  static func size(for model: VM) -> CGSize
}

// MARK: View Model
struct EventCellViewModel: ViewModel {
    let identifier: String
    let description: String
    let magnitudo : String
    
    static func == (l: EventCellViewModel, r: EventCellViewModel) -> Bool {
        if l.identifier != r.identifier {return false}
        return true
    }
}


// MARK: - View
class EventCell: UICollectionViewCell, ConfigurableCell, SizeableCell {
    static func size(for model: EventCellViewModel) -> CGSize { //MAGIC FUNCTION
        //let textWidth = UIScreen.main.bounds.width * AttractionCell.maxTextWidth
        //let textHeight = model.attractionName.height(constraintedWidth: textWidth, font: font)
        let textHeight: CGFloat = 260
        return CGSize(width: UIScreen.main.bounds.width,
                      height: textHeight + 2)
    }
    
    static var identifierForReuse: String = "EventCell"
    
    //MARK: Subviews
    var nameLabel = UILabel()
    var descriptionLabel = UILabel()
    var magnitudoLabel = UILabel()
    var map = MapView()
    var test_view = UIView()
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.style()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    func setup() {
        self.addSubview(self.nameLabel)
        self.addSubview(self.descriptionLabel)
        self.addSubview(self.test_view)
        self.addSubview(self.magnitudoLabel)
        self.map.setup()
        self.map.style()
        self.addSubview(self.map)
        
        
    }
    
    //MARK: Style
    func style() {
        //layoutSubviews()
        self.backgroundColor = .systemBackground
        test_view.backgroundColor = .systemRed
        
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        self.nameLabel.pin.top(0).left(20).sizeToFit()
        self.descriptionLabel.font = UIFont(name: "Futura", size: 20)
        self.descriptionLabel.textColor = .systemGray
        self.descriptionLabel.pin.below(of: nameLabel).left(30).sizeToFit()
        self.descriptionLabel.font = UIFont(name: "Futura", size: 15)
        //self.test_view.pin.height(10).width(20)
        self.map.pin.below(of: descriptionLabel)
        self.test_view.pin.below(of: descriptionLabel)
        //self.magnitudoLabel.pin.after(of: nameLabel).sizeToFit().marginRight(0)
        self.magnitudoLabel.pin.right(pin.safeArea).sizeToFit().marginRight(10)
        self.magnitudoLabel.font = UIFont(name: "Futura", size: 12)
        self.magnitudoLabel.textColor = .systemGray
    }
    
    //MARK: Update
    func update(oldModel: EventCellViewModel?) {
        guard let model = self.model else {return}
        nameLabel.text = model.identifier
        descriptionLabel.text = model.description
        magnitudoLabel.text = model.magnitudo
        self.setNeedsLayout()
    }
}

class MapView : UIView, ViewControllerModellableView{
    var mapView : GMSMapView!
    func setup() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.mapView.settings.tiltGestures = true
        self.mapView.settings.compassButton = true
        self.mapView.animate(to: camera)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        self.addSubview(self.mapView)
        
    }
    func style(){
        backgroundColor = .systemGray
        
    }
    
    func update(oldModel: MainViewModel?) {
        self.setNeedsLayout()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.mapView.pin.height(200).width(414)
    }
}


// MARK: - DiffAware conformance
extension EventCellViewModel: DiffAware {
    var diffId: Int { return self.identifier.hashValue }

    static func compareContent(_ a: EventCellViewModel, _ b: EventCellViewModel) -> Bool {
        return a.identifier == b.identifier
    }
}
