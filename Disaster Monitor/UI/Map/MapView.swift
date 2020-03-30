//
//  MapView.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 17/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import CoreLocation
import Tempura
import GoogleMaps
import GooglePlaces
import GoogleMapsUtils

// MARK: - ViewModel
struct MapViewModel: ViewModelWithState {
    var state: AppState
    init?(state: AppState) {
        self.state = state
    }
}

// MARK: - View
class MapView: UIView, ViewControllerModellableView {
   
    var events: [Event] = []
    let mapView = GMSMapView()
    var heatmapLayer = GMUHeatmapTileLayer()
    let segmentedControl = UISegmentedControl(items: ["Normal", "Satellite", "Heatmap"])
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var didTapActionButton: (() -> ())?

    // MARK: - Setup
    func setup() {
        setupSearchBar()
        setupSegmentedControl()
        LocationService.sharedInstance.delegate = self
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
        navigationItem?.searchController = searchController

        // Prevent the navigation bar from being hidden when searching
        searchController?.hidesNavigationBarDuringPresentation = false
    }
    
    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
        segmentedControl.backgroundColor = .systemBackground
    }

    func style() {
        backgroundColor = .systemBackground
        navigationBar?.prefersLargeTitles = false
        navigationItem?.title = "Around You"
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
    
    func update(oldModel: MapViewModel?) {
        guard let model = model else { return }
        events = model.state.events
        if segmentedControl.selectedSegmentIndex == 0 || segmentedControl.selectedSegmentIndex == 1 {
            setupMarkers()
        }
        else {
            setupHeatmap()
        }
    }

    override func layoutSubviews() {
        addSubview(mapView)
        mapView.addSubview(segmentedControl)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.topAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        segmentedControl.leftAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
    }
    
    private func mapViewStyle() {
        // myLocationEnabled draws a light blue dot where the user is located, while
        // myLocationButton, when set to true, adds a button to the map that, when tapped, centers the map on the user’s location
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        // compassButton displays only when map is NOT in the north direction
        mapView.settings.compassButton = false
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.tiltGestures = true
    }

    private func setupMarkers() {
        mapView.clear()
        heatmapLayer.map = nil
        if !events.isEmpty {
            for event in events {
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
    }
    
    private func setupHeatmap() {
        mapView.clear()
        mapView.animate(toZoom: 0)
        var list = [GMUWeightedLatLng]()
        if !events.isEmpty {
            for event in events {
                let lon = event.coordinates[0]
                let lat = event.coordinates[1]
                let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(lat , lon), intensity: 1.0)
                list.append(coords)
            }
            heatmapLayer.radius = 50
            heatmapLayer.weightedData = list
            heatmapLayer.clearTileCache()
            heatmapLayer.map = mapView
        }
    }
    
    @objc func didTapActionButtonFunc() {
        didTapActionButton?()
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            setupMarkers()
            mapView.mapType = GMSMapViewType.normal
        case 1:
            setupMarkers()
            mapView.mapType = GMSMapViewType.satellite
        case 2:
            setupHeatmap()
            mapView.mapType = GMSMapViewType.terrain
        default:
            break
        }
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
        if segmentedControl.selectedSegmentIndex == 0 || segmentedControl.selectedSegmentIndex == 1 {
            setupMarkers()
        }
        else {
            setupHeatmap()
        }
    }
    
}

extension MapView: LocationServiceDelegate, GMSAutocompleteResultsViewControllerDelegate {
    
    func tracingLocation(currentLocation: CLLocation) {
        /*
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude

        print("latitude \(lat), longitude \(lon)")
        */
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        // print("tracing Location Error : \(error.description)")
    }

    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
                
        let newLocation = GMSCameraPosition(target: place.coordinate, zoom: 12, bearing: 0, viewingAngle: 0)
        mapView.animate(to: newLocation)
    }

    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
}
