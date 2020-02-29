//
//  MainTableViewCell.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 28/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import UIKit
import Tempura
import Katana
import GooglePlaces
import GoogleMaps

class MainTableViewCell: UITableViewCell/*, ModellableView*/{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
        self.style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Subviews
    var nameLabel = UILabel()
    var descriptionLabel = UILabel()
    var magnitudoLabel = UILabel()
    //var map = MapView()
    
    
    // MARK: Setup
    func setup() {
        self.addSubview(self.nameLabel)
        self.addSubview(self.descriptionLabel)
        self.addSubview(self.magnitudoLabel)
        //self.map.setup()
        //self.map.style()
        //self.addSubview(self.map)
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
        self.descriptionLabel.pin.below(of: nameLabel).left(20).sizeToFit()
        self.descriptionLabel.font = UIFont(name: "Futura", size: 15)
        //self.map.pin.below(of: descriptionLabel)//
        self.magnitudoLabel.pin.right(pin.safeArea).sizeToFit().marginRight(10)
        self.magnitudoLabel.font = UIFont(name: "Futura", size: 20)
        self.magnitudoLabel.textColor = .systemGray
    }
    
    func setupCell(event: Event){
        nameLabel.text = event.name
        descriptionLabel.text = event.description
        magnitudoLabel.text = String(event.magnitudo)
        
        
        /*let coord1 = event.coordinates[0]
        let coord2 = event.coordinates[1]
        map.mapView.camera = GMSCameraPosition.camera(withLatitude: coord2, longitude: coord1, zoom: 10)
        map.mapView.animate(to: map.mapView.camera)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coord2, longitude: coord1)
        marker.map = map.mapView*/
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
        do {
            if traitCollection.userInterfaceStyle == .dark {
                // Set the map style by passing the URL of the local file.
                if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                  mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                } else {
                  NSLog("Unable to find style.json")
                }
            }
        } catch {
          NSLog("One or more of the map styles failed to load. \(error)")
        }
        
    }
    func style(){
        backgroundColor = superview?.backgroundColor
    }
    
    func update(oldModel: MainViewModel?) {
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.mapView.pin.width(414).height(550)
    }
}

