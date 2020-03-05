//
//  EventView.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 25/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura
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
        self.id = localState.id
        self.event = localState.event
    }
    
}


// MARK: - View
class EventView: UIView, ViewControllerModellableView {
    
    var mapView = GMSMapView()
    var coordinate = UILabel()
    var magnitude = UILabel()
    var time = UILabel()
    var depth = UILabel()
    
    var didTapClose: (() -> ())?
    
    func setup() {
        addSubview(mapView)
        addSubview(coordinate)
        addSubview(magnitude)
        addSubview(time)
        addSubview(depth)
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
        let defaultValue: String = "Loading data..."
        guard let model = self.model else { return }
        
        self.navigationItem?.title = model.event?.name
        
        let coord_str: String = String(format:"coordinates: %f  %f", model.event?.coordinates[0] ?? defaultValue, model.event?.coordinates[1] ?? defaultValue)
        self.coordinate.text = coord_str
        
        let magnitudo_model: String = String(format: "%f", model.event?.magnitudo ?? defaultValue)
        let magnitudo_label: String = String(magnitudo_model.prefix(through: magnitudo_model.index(magnitudo_model.startIndex, offsetBy: 2)))
        let magnitude_str = String(format:"magnitude: %@", magnitudo_label)
        self.magnitude.text = magnitude_str
        
        self.time.text = String(format: "origin time: %@", model.event?.time ?? defaultValue)
        
        self.depth.text = String(format: "depth: %@ km", model.event?.depth ?? defaultValue)
        
        updateMapView(latitude: (model.event?.coordinates[1]) ?? 0, longitude: (model.event?.coordinates[0]) ?? 0)
    }
    
    private func updateMapView(latitude: Double, longitude: Double) {
        let location = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 10)
        mapView.animate(to: location)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        coordinate.translatesAutoresizingMaskIntoConstraints = false
        coordinate.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        coordinate.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        coordinate.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        
        magnitude.translatesAutoresizingMaskIntoConstraints = false
        magnitude.topAnchor.constraint(equalTo: self.coordinate.topAnchor, constant: 30).isActive = true
        magnitude.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        magnitude.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        
        time.translatesAutoresizingMaskIntoConstraints = false
        time.topAnchor.constraint(equalTo: self.magnitude.topAnchor, constant: 30).isActive = true
        time.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        time.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        
        depth.translatesAutoresizingMaskIntoConstraints = false
        depth.topAnchor.constraint(equalTo: self.time.topAnchor, constant: 30).isActive = true
        depth.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        depth.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        
        // Note: no safe area for the map is wanted!
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.depth.topAnchor, constant: 100).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mapView.widthAnchor.constraint(equalToConstant: self.bounds.width).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 0.7 * self.bounds.height).isActive = true
    }
    
    @objc func didTapCloseFunc() {
        didTapClose?()
    }
    
}
