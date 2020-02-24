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
    let magnitudo: Float
    let description: String
    let coord: [Double]
    
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
        self.addSubview(self.magnitudoLabel)
        self.map.setup()
        self.map.style()
        self.addSubview(self.map)
    }
    
    //MARK: Style
    func style() {
        //layoutSubviews()
        self.backgroundColor = .systemBackground
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        self.nameLabel.pin.top(0).left(20).sizeToFit()
        self.descriptionLabel.font = UIFont(name: "Futura", size: 20)
        self.descriptionLabel.textColor = .systemGray
        self.descriptionLabel.pin.below(of: nameLabel).left(30).sizeToFit()
        self.descriptionLabel.font = UIFont(name: "Futura", size: 15)
        self.map.pin.below(of: descriptionLabel)
        self.magnitudoLabel.pin.right(pin.safeArea).sizeToFit().marginRight(10)
        self.magnitudoLabel.font = UIFont(name: "Futura", size: 12)
        self.magnitudoLabel.textColor = .systemGray
    }
    
    //MARK: Update
    func update(oldModel: EventCellViewModel?) {
        guard let model = self.model else {return}
        if model.identifier != ""{
            nameLabel.text = model.identifier
            descriptionLabel.text = model.description
            magnitudoLabel.text = String(model.magnitudo)
            //let coord1 = Double(model.coord.split(separator: " ")[0]) ?? 0
            let coord1 = model.coord[0]
            //let coord2 = Double(model.coord.split(separator: " ")[1]) ?? 0
            let coord2 = model.coord[1]
            map.mapView.camera = GMSCameraPosition.camera(withLatitude: coord2, longitude: coord1, zoom: 10)
            map.mapView.animate(to: map.mapView.camera)
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: coord2, longitude: coord1)
            marker.map = map.mapView
            self.setNeedsLayout()
        }
    }
}

struct MapViewModel: ViewModel, Equatable {
    var coordList : [[String]]
}

class MapView : UIView, ModellableView{
    var mapView : GMSMapView!
    func setup() {
        let camera = GMSCameraPosition.camera(withLatitude: 999, longitude: 999, zoom: 0)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.addSubview(self.mapView)
        
    }
    func style(){
        backgroundColor = .systemGray
        
    }
    
    func update(oldModel: MainViewModel?) {
        guard let model = self.model else { return }
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
