//
//  ProfileView.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 17/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import Foundation
import Katana
import Tempura
import CoreLocation
import GoogleMaps
import GooglePlaces

// MARK: - ViewModel
struct ProfileViewModel: ViewModelWithState {
    var state: AppState
    init?(state: AppState) {
        self.state = state
    }
}

// MARK: - View
class ProfileView: UIView, ViewControllerModellableView {
   
    let locationManager = CLLocationManager()
    let mapView = GMSMapView()
    var didTapActionButton: (() -> ())?

    func setup() {
        setupLocation()
    }

    func style() {
        backgroundColor = .systemBackground
        navigationBar?.prefersLargeTitles = true
        navigationItem?.title = "My Profile"
        navigationItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapActionButtonFunc))
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            /*
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: "FuturaStd-Bold", size: 30) ??
            UIFont.boldSystemFont(ofSize: 30)] // cambia aspetto del titolo
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: "FuturaStd-Bold", size: 30) ??
            UIFont.boldSystemFont(ofSize: 30)] // cambia aspetto del titolo (con prefersLargeTitles = true)
            */
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black] // cambia aspetto del titolo
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black] // cambia aspetto del titolo (con prefersLargeTitles = true)
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
        mapViewStyle()
    }

    func update(oldModel: MainViewModel?) {
    }

    override func layoutSubviews() {
        self.addSubview(mapView)
        mapView.pin.top(pin.safeArea).left().right().bottom()
    }
    
    private func setupLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    private func mapViewStyle() {
        // myLocationEnabled draws a light blue dot where the user is located, while
        // myLocationButton, when set to true, adds a button to the map that, when tapped, centers the map on the user’s location
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        // compassButton displays only when map is NOT in the north direction
        mapView.settings.compassButton = true
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.tiltGestures = true
        
        /*
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
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
        */
    }
    
    @objc func didTapActionButtonFunc() {
       didTapActionButton?()
    }
    
}

// MARK: - CLLocationManagerDelegate
extension ProfileView: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    guard status == .authorizedWhenInUse else {
      return
    }
    locationManager.startUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }
      
    // This updates the map’s camera to center around the user’s current location
    mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
      
    // Tell locationManager you’re no longer interested in updates
    // locationManager.stopUpdatingLocation()
  }
    
}
