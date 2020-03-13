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

    var event: Event?
    
    init?(state: AppState?, localState: EventControllerLocalState) {
        self.event = state?.events.first(where: {$0.id == localState.id})
    }
    
}

// MARK: - View
class EventView: UIView, ViewControllerModellableView {
    var id: String?
    var mapView = GMSMapView()
    var latitude: Double?
    var longitude: Double?
    
    var coordinate = UILabel()
    var magnitude = UILabel()
    var time = UILabel()
    var depth = UILabel()
        
    // MARK: Setup
    func setup() {
        addSubview(mapView)
        addSubview(coordinate)
        addSubview(magnitude)
        addSubview(time)
        addSubview(depth)
    }
    
    // MARK: Style
    func style() {
        backgroundColor = .systemBackground
        navigationItem?.largeTitleDisplayMode = .never
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.label] // cambia aspetto del titolo
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label] // cambia aspetto del titolo (con prefersLargeTitles = true)
            navigationBar?.tintColor = .systemBlue // tintColor changes the color of the UIBarButtonItem
            navBarAppearance.backgroundColor = .systemGray6 // cambia il colore dello sfondo della navigation bar
            // navigationBar?.isTranslucent = false // da provare la differenza tra true/false solo con colori vivi
            navigationBar?.standardAppearance = navBarAppearance
            navigationBar?.scrollEdgeAppearance = navBarAppearance
        } else {
            navigationBar?.tintColor = .systemBlue
            navigationBar?.barTintColor = .systemGray6
            // navigationBar?.isTranslucent = false
        }
    }
    
    // MARK: Update
    func update(oldModel: EventViewModel?) {
        mapView.clear()
        let defaultValue: String = "Loading data..."
        guard let model = self.model else { return }
        
        self.navigationItem?.title = model.event?.name
        
        let coord_str: String = String(format:"coordinates: %f  %f", model.event?.coordinates[0] ?? defaultValue, model.event?.coordinates[1] ?? defaultValue)
        self.coordinate.text = coord_str
        self.coordinate.textColor = .label
        
        let magnitudo_model: String = String(format: "%f", model.event?.magnitudo ?? defaultValue)
        let magnitudo_label: String = String(magnitudo_model.prefix(through: magnitudo_model.index(magnitudo_model.startIndex, offsetBy: 2)))
        let magnitude_str = String(format:"magnitude: %@", magnitudo_label)
        self.magnitude.text = magnitude_str
        self.magnitude.textColor = .label
        
        self.time.text = String(format: "origin time: %@", model.event?.date as CVarArg? ?? defaultValue)
        self.time.textColor = .label
        
        self.depth.text = String(format: "depth: %f km", model.event?.depth ?? defaultValue)
        self.depth.textColor = .label
        
        latitude = model.event?.coordinates[1] ?? 0
        longitude = model.event?.coordinates[0] ?? 0
        updateMapView()
    }
    
    private func updateMapView() {
        let location = GMSCameraPosition.camera(withLatitude: latitude!, longitude: longitude!, zoom: 10)
        mapView.animate(to: location)
        setupMarker()
    }
    
    private func setupMarker() {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
    }

    // MARK: Layout
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
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let mapStyleString: String
        
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            mapStyleString = "light_map_style"
        case .dark:
            mapStyleString = "dark_map_style"
        default:
            mapStyleString = "light_map_style"
        }
        
        do {
          // Set the map style by passing the URL of the local file.
          if let styleURL = Bundle.main.url(forResource: mapStyleString, withExtension: "json") {
            mapView.clear()
            mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
          } else {
            NSLog("Unable to find style.json")
          }
        } catch {
          NSLog("One or more of the map styles failed to load. \(error)")
        }
        setupMarker()
    }
    
}
