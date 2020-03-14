//
//  MapView.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 17/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import Tempura
import CoreLocation
import GoogleMaps
import GooglePlaces
import UserNotifications

// MARK: - ViewModel
struct MapViewModel: ViewModelWithState {
    var state: AppState
    init?(state: AppState) {
        self.state = state
    }
}

// MARK: - View
class MapView: UIView, ViewControllerModellableView, UNUserNotificationCenterDelegate {
   
    let locationManager = CLLocationManager()
    let mapView = GMSMapView()
    let segmentedControl = UISegmentedControl(items: ["Normal", "Satellite"])
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var didTapActionButton: (() -> ())?

    var actualPosition: CLLocation?

    // MARK: - Setup
    func setup() {
        setupLocation()
        // setupLocalNotifications()
        setupSearchBar()
        setupSegmentedControl()
    }
    
    private func setupLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            //locationManager.allowsBackgroundLocationUpdates = true
            //locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
        }
    }
    
    private func setupLocalNotifications() {
        let application = UIApplication.shared

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (isAuthorized, error) in
                if (error != nil) {
                    print(error!)
                }
                else {
                    if (isAuthorized) {
                        print("authorized")
                        NotificationCenter.default.post(Notification(name: Notification.Name("AUTHORIZED")))
                    }
                    else {
                        /*
                        let pushPreference = UserDefaults.standard.bool(forKey: "PREF_PUSH_NOTIFICATIONS")
                        if pushPreference == false {
                        }
                        */
                        let alert = UIAlertController(title: "Turn on Notifications", message: "Push notifications are turned off.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Turn on notifications", style: .default, handler: { (alertAction) in
                            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    // Checking for setting is opened or not
                                    print("Setting is opened: \(success)")
                                })
                            }
                            // UserDefaults.standard.set(true, forKey: "PREF_PUSH_NOTIFICATIONS")
                        }))
                        alert.addAction(UIAlertAction(title: "No thanks.", style: .default, handler: { (actionAlert) in
                            print("user denied")
                            // UserDefaults.standard.set(true, forKey: "PREF_PUSH_NOTIFICATIONS")
                        }))
                        let viewController = UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController
                        DispatchQueue.main.async {
                            viewController?.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
    
    private func postLocalNotifications(eventTitle: String, region: CLCircularRegion) {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = eventTitle
        content.body = "You've entered a new region"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let notificationRequest:UNNotificationRequest = UNNotificationRequest(identifier: "Region", content: content, trigger: trigger)
        
        center.add(notificationRequest, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
                print(error)
            }
            else{
                print("added")
            }
        })
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
        navigationItem?.title = "Around Me"
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
        if model.state.events.count != 0 {
            setupMarkers()
        }
        mapViewStyle()
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
    
    @objc func didTapActionButtonFunc() {
        didTapActionButton?()
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                mapView.mapType = GMSMapViewType.normal
            case 1:
                mapView.mapType = GMSMapViewType.satellite
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
            mapView.clear()
            mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
          } else {
            NSLog("Unable to find style.json")
          }
        } catch {
          NSLog("One or more of the map styles failed to load. \(error)")
        }
        setupMarkers()
    }
    
}

// MARK: - CLLocationManagerDelegate
extension MapView: CLLocationManagerDelegate, GMSAutocompleteResultsViewControllerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { return }
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        actualPosition = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        /*
        let region :CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(43.61871, -116.214607), radius: 100, identifier: "Boise")
        if region.contains(actualPosition!.coordinate) {
            postLocalNotifications(eventTitle: region.identifier, region: region)
        }
        */
        
        // This updates the map’s camera to center around the user’s current location
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
          
        // Tell locationManager you’re no longer interested in updates
        // locationManager.stopUpdatingLocation()
    }

    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
        /*
        // Do something with the selected place.
        print("Place name: \(String(describing: place.name))")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        */
                
        let newLocation = GMSCameraPosition(target: place.coordinate, zoom: 12, bearing: 0, viewingAngle: 0)
        mapView.animate(to: newLocation)
    }

    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
}