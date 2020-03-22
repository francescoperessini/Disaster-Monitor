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
        self.event = state?.events.first(where:{$0.id == localState.id})
    }
}

// MARK: - View
class EventView: UIView, ViewControllerModellableView {
    
    let mainVStackView = UIStackView()
    
    let infoVStackView = UIStackView()
    var placeLabel = UILabel()
    
    var mapView = GMSMapView()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
        
    func setup() {
        addSubview(mainVStackView)
        setupMainVStackView()
        setupInfoVStackView()
        setupMapView()
    }
    
    private func setupMainVStackView() {
        mainVStackView.axis = .vertical
        mainVStackView.distribution = .fill
        mainVStackView.alignment = .fill
        mainVStackView.spacing = 0
        
        mainVStackView.addArrangedSubview(infoVStackView)
        mainVStackView.addArrangedSubview(mapView)
    }
    
    private func setupInfoVStackView() {
        infoVStackView.axis = .vertical
        infoVStackView.distribution = .fill
        infoVStackView.alignment = .fill
        infoVStackView.spacing = 5.0
        
        let view = UIView()
        view.backgroundColor = .yellow
        
        infoVStackView.addArrangedSubview(view)
    }
    
    private func setupMapView() {
        // compassButton displays only when map is NOT in the north direction
        mapView.settings.compassButton = true
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.tiltGestures = true
    }
    
    func style() {
        backgroundColor = .systemGray6
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
        placeLabelStyle()
    }
    
    private func placeLabelStyle() {
        placeLabel.font = UIFont.systemFont(ofSize: 18)
        placeLabel.textColor = .label
    }
    
    func update(oldModel: EventViewModel?) {
        guard let model = self.model else { return }
        if model.event != nil {
            placeLabel.text = model.event?.name
            latitude = (model.event?.coordinates[1])!
            longitude = (model.event?.coordinates[0])!
            updateMapView()
        }
    }
    
    private func updateMapView() {
        mapView.clear()
        let location = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 10)
        mapView.animate(to: location)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainVStackView.translatesAutoresizingMaskIntoConstraints = false
        mainVStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        mainVStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mainVStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mainVStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.heightAnchor.constraint(equalToConstant: 500).isActive = true
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
            mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
          } else {
            NSLog("Unable to find style.json")
          }
        } catch {
          NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    
}
