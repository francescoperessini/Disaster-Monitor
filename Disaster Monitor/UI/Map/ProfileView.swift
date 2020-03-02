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
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var didTapActionButton: (() -> ())?
    
    var actualPosition: CLLocation?
    var nearestLocations_tmp: [Event] = []
    var nearestLocations: [Event] = []

    func setup() {
        setupLocation()
        setupSearchBar()
    }

    func style() {
        backgroundColor = .systemBackground
        navigationBar?.prefersLargeTitles = false
        navigationItem?.title = "My Profile"
        navigationItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapActionButtonFunc))
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
        mapViewStyle()
    }

    func update(oldModel: MainViewModel?) {
        guard let model = model else { return }
        if model.state.events.count != 0 {
            setupMarkers()
            
            nearestLocations_tmp = model.state.events
            nearestLocations.removeAll()
            if actualPosition != nil {
                for _ in 0...19 {
                    let tmp = closestLocation(locations: self.nearestLocations_tmp, closestToLocation: self.actualPosition!)
                    nearestLocations.append(tmp!)
                }
                setupGeoFenceRegions()
            }
        }
    }

    override func layoutSubviews() {
        self.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mapView.widthAnchor.constraint(equalToConstant: self.bounds.width).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: self.bounds.height).isActive = true
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
        let circ = GMSCircle(position: marker.position, radius: 100000)
        circ.fillColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.10)
        circ.strokeColor = .red
        circ.strokeWidth = 2
        circ.map = mapView
        */
    }
    
    private func setupSearchBar() {
        resultsViewController = GMSAutocompleteResultsViewController()
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        resultsViewController?.autocompleteFilter = filter
        resultsViewController?.delegate = self

        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController

        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        // navigationItem?.titleView = searchController?.searchBar
        navigationItem?.searchController = searchController

        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        // definesPresentationContext = true

        // Prevent the navigation bar from being hidden when searching
        searchController?.hidesNavigationBarDuringPresentation = false
    }
    
    private func setupMarkers() {
        mapView.clear()
        for event in (model?.state.events)! {
            let longitude = event.coordinates[0]
            let latitude = event.coordinates[1]
            let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let marker = GMSMarker(position: position)
            marker.title = event.name
            marker.snippet = "Magnitudo: \(String(event.magnitudo))"
            marker.appearAnimation = GMSMarkerAnimation.pop
            marker.map = mapView
        }
    }
    
    private func closestLocation(locations: [Event], closestToLocation location: CLLocation) -> Event? {
        if let closestLocation = locations.min(by: { location.distance(from: CLLocation(latitude: $0.coordinates[1], longitude: $0.coordinates[0])) < location.distance(from: CLLocation(latitude: $1.coordinates[1], longitude: $1.coordinates[0])) }) {
            nearestLocations_tmp = nearestLocations_tmp.filter{$0 != closestLocation}
            return closestLocation
        } else {
            print("coordinates is empty")
            return nil
        }
    }
    
    private func setupGeoFenceRegions() {
        
        
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
                
        for event in nearestLocations {
            let longitude = event.coordinates[0]
            let latitude = event.coordinates[1]
            let identifier = event.name
            let geoFenceRegion: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: 100, identifier: identifier)
            // geoFenceRegion.notifyOnEntry = true
            // geoFenceRegion.notifyOnExit = false
            locationManager.startMonitoring(for: geoFenceRegion)
        }
        print(locationManager.monitoredRegions.count)
    }
    
    @objc func didTapActionButtonFunc() {
        didTapActionButton?()
    }
    
}

// MARK: - CLLocationManagerDelegate
extension ProfileView: CLLocationManagerDelegate, GMSAutocompleteResultsViewControllerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { return }
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        actualPosition = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        // This updates the map’s camera to center around the user’s current location
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
          
        // Tell locationManager you’re no longer interested in updates
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered: \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited: \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
        print(error)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }

    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
        // Do something with the selected place.
        print("Place name: \(String(describing: place.name))")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
                
        let newLocation = GMSCameraPosition(target: place.coordinate, zoom: 12, bearing: 0, viewingAngle: 0)
        mapView.animate(to: newLocation)
    }

    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error){
        print("Error: ", error.localizedDescription)
    }
    
}
