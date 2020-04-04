//
//  AddMonitoredPlaceView.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 20/03/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura
import GoogleMaps
import GooglePlaces

// MARK: - ViewModel
struct AddMonitoredPlaceViewModel: ViewModelWithState {
    var state: AppState
    init?(state: AppState) {
        self.state = state
    }
}

// MARK: - View
class AddMonitoredPlaceView: UIView, ViewControllerModellableView {

    var searchController: UISearchController?
    var resultsViewController: GMSAutocompleteResultsViewController?
    var didTapClose: (()  -> ())?
    var didTapApply: ((String, [Double], Float, Double)  -> ())?
    var addMonitoredEventsTableView = UITableView(frame: CGRect.zero, style: .grouped)
    var coordinatesToSend: CLLocationCoordinate2D?
    var mapView: GMSMapView?
    var searchString: String?
    
    var cellMagnitudo: AddMonitoredRegionCell?
    var cellRadius: AddMonitoredRegionCell?
    
    struct Cells {
        static let addMonitoredRegionCell = "AddMonitoredRegionCell"
    }
    func setup() {
        addMonitoredEventsTableView.isScrollEnabled = false
        addSubview(addMonitoredEventsTableView)
        configureSettingsTableView()
        setupSearchBar()
    }
    
    private func configureSettingsTableView() {
        setAddMonitoredRegionViewDelegates()
        addMonitoredEventsTableView.register(AddMonitoredRegionCell.self, forCellReuseIdentifier: Cells.addMonitoredRegionCell)
    }

    private func setAddMonitoredRegionViewDelegates() {
        addMonitoredEventsTableView.delegate = self
        addMonitoredEventsTableView.dataSource = self
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
    
    func style() {
        backgroundColor = .systemBackground
        navigationItem?.title = "Add a monitored region"
        navigationItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseFunc))
        navigationItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapApplyFunc))
        navigationItem?.rightBarButtonItem?.isEnabled = false
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.label]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
            navigationBar?.tintColor = .systemBlue
            navBarAppearance.backgroundColor = .systemGray6
            navigationBar?.standardAppearance = navBarAppearance
            navigationBar?.scrollEdgeAppearance = navBarAppearance
        } else {
            navigationBar?.tintColor = .systemBlue
            navigationBar?.barTintColor = .systemGray6
        }
    }
    @objc func didTapCloseFunc(){
        didTapClose?()
    }
    @objc func didTapApplyFunc(){
        let r = Float((cellMagnitudo?.stepperControlMagnitudo.value)!)
        let m = cellRadius!.stepperControlRadius.value
        didTapApply?(searchString ?? "Unknown place", [Double(coordinatesToSend!.latitude), Double(coordinatesToSend!.longitude)],r ,m )
    }
    func update(oldModel: AddMonitoredPlaceViewModel?) {

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addMonitoredEventsTableView.pin.top().left().right().bottom()
    }
    
}

// MARK: - CLLocationManagerDelegate
extension AddMonitoredPlaceView: GMSAutocompleteResultsViewControllerDelegate, GMSMapViewDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        let newLocation = GMSCameraPosition(target: place.coordinate, zoom: 12, bearing: 0, viewingAngle: 0)
        mapView?.animate(to: newLocation)
        searchString = place.name
    }

    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        coordinatesToSend = coordinate
        let marker = GMSMarker(position: coordinate)
        marker.title = "Hello World"
        marker.map = mapView
        
        let circleCenter = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let circ = GMSCircle(position: circleCenter, radius: 1000)
        circ.map = mapView
        
        navigationItem?.rightBarButtonItem?.isEnabled = true
    }
}

extension AddMonitoredPlaceView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = AddMonitoredRegionOption(rawValue: indexPath.row) else { return 0.0 }
        switch option {
            case .map: return 400
            default: return 48
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = AddMonitoredRegionOption(rawValue: indexPath.row) else { return 0.0 }
        switch option {
            case .map: return 400
            default: return 48
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return AddMonitoredRegionSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddMonitoredRegionOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return AddMonitoredRegionSection(rawValue: section)?.description
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addMonitoredEventsTableView.dequeueReusableCell(withIdentifier: Cells.addMonitoredRegionCell, for: indexPath) as! AddMonitoredRegionCell

        let type = AddMonitoredRegionOption(rawValue: indexPath.row)
        cell.sectionType = type
        
        /*guard let bool = type?.containsMap else{return cell}
        if bool{
            mapView = cell.mapView
            cell.mapView.delegate = self
        }*/
        
        if type?.containsMap ?? false {
            mapView = cell.mapView
            cell.mapView.delegate = self
        } else if type?.containsStepperMagnitudo ?? false {
            cellMagnitudo = cell
        } else if type?.containsStepperRadius ?? false {
            cellRadius = cell
        }
        return cell
    }
    
}
