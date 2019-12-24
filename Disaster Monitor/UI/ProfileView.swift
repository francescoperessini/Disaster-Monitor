//
//  MainView.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 17/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import Foundation
import Katana
import Tempura
import GoogleMaps
import GooglePlaces

// MARK: - ViewModel
struct ProfileViewModel: ViewModelWithState {
    // Per ogni schermo c'è una sola view con un ViewModelWithState
    var name: String
    init?(state: AppState) {
        self.name = state.name
    }
}


// MARK: - View
class ProfileView: UIView, ViewControllerModellableView {   //
   
    let maps = BigMapView()
    
    // setup
    func setup() {      // 1. Assemblaggio della view, chiamata una volta sola
        backgroundColor = .white
        maps.setup()
        maps.style()
        self.addSubview(self.maps)
    }

    // style
    func style() {      // 2. Cosmetics, chiamata una sola volta
        
    }

    // update
    func update(oldModel: MainViewModel?) {  // Chiamato ad ogni aggiornamento di stato
        guard let model = self.model else { return }
        self.setNeedsLayout()
    }

    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
        maps.pin.top(pin.safeArea).width(100).aspectRatio().sizeToFit()
    }
}


class BigMapView : UIView, ViewControllerModellableView{
    var mapView : GMSMapView!
    func setup() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        self.mapView.settings.scrollGestures = true
        self.mapView.animate(to: camera)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        let circ = GMSCircle(position: marker.position, radius: 100000)
        circ.fillColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.10)
        circ.strokeColor = .red
        circ.strokeWidth = 2
        circ.map = mapView
        self.addSubview(self.mapView)
        
    }
    func style(){
        backgroundColor = .systemBackground
    }
    
    func update(oldModel: MainViewModel?) {
        self.setNeedsLayout()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.mapView.pin.height(800).width(414)
    }
}
