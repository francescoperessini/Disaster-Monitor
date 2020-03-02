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
import GooglePlaces
import GoogleMaps

// MARK: - ViewModel
struct EventViewModel: ViewModelWithLocalState {
    var id: String?
    var event: DetailedEvent?
    
    init(id: String, event: DetailedEvent) {
        self.id = id
        self.event = event
    }
    
    init?(state: AppState?, localState: EventControllerLocalState) {
        guard let state = state else {return nil}
        self.id = localState.id
        self.event = localState.event
    }
}


// MARK: - View
class EventView: UIView, ViewControllerModellableView {
    
    var map = MapView()
    var coordinate = UILabel()
    var magnitude = UILabel()
    var time = UILabel()
    var depth = UILabel()
    
    var didTapClose: (() -> ())?
    
    @objc func didTapCloseFunc() {
        didTapClose?()
    }
    
    func setup() {
        self.map.setup()
        self.map.style()
        self.addSubview(self.map)
        self.addSubview(self.coordinate)
        self.addSubview(self.magnitude)
        self.addSubview(self.time)
        self.addSubview(self.depth)
    }
    
    func style() {
        navigationItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapCloseFunc))
        backgroundColor = .white
        navigationBar?.prefersLargeTitles = false
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black] // cambia aspetto del titolo
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black] // cambia aspetto del titolo (con prefersLargeTitles = true)
            navigationBar?.tintColor = .systemBlue
            navBarAppearance.backgroundColor = .systemGray6 // cambia il colore dello sfondo della navigation bar
            navigationBar?.standardAppearance = navBarAppearance
            navigationBar?.scrollEdgeAppearance = navBarAppearance
        } else {
            navigationBar?.tintColor = .black
            navigationBar?.barTintColor = .systemGray6
        }
    }

    func update(oldModel: EventViewModel?) {
        let defaultValue: String = "Loading data"
        guard let model = self.model else {return}
        self.navigationItem?.title = model.event?.name
        
        let coord_str: String = String(format:"coordinates: %f  %f", model.event?.coordinates[0] ?? defaultValue, model.event?.coordinates[1] ?? defaultValue)
        self.coordinate.text = coord_str
        
        let magnitudo_model: String = String(format: "%f", model.event?.magnitudo ?? defaultValue)
        let magnitudo_label: String  = String(magnitudo_model.prefix(through: magnitudo_model.index(magnitudo_model.startIndex, offsetBy: 2)))
        let magnitude_str = String(format:"magnitude: %@", magnitudo_label)
        self.magnitude.text = magnitude_str
        
        self.time.text = String(format: "origin time: %@", model.event?.time ?? defaultValue)
        
        self.depth.text = String(format: "depth: %@ km", model.event?.depth ?? defaultValue)
        
        let coord1 = model.event?.coordinates[0]
        let coord2 = model.event?.coordinates[1]
        
        map.mapView.camera = GMSCameraPosition.camera(withLatitude: coord2 ?? 0, longitude: coord1 ?? 0, zoom: 10)
        map.mapView.animate(to: map.mapView.camera)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coord2 ?? 0, longitude: coord1 ?? 0)
        marker.map = map.mapView
        self.setNeedsLayout()
    }

    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
        self.map.pin.top(33%).height(66%)
        self.coordinate.pin.top(pin.safeArea.top + 10).sizeToFit().left(30).marginTop(10)
        self.magnitude.pin.below(of: self.coordinate).sizeToFit().left(30).marginTop(10)
        self.time.pin.below(of: self.magnitude).sizeToFit().left(30).marginTop(10)
        self.depth.pin.below(of: self.time).sizeToFit().left(30).marginTop(10)
    }
}
