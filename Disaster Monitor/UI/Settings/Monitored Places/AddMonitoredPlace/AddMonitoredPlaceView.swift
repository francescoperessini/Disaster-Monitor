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
    
    var addMonitoredEventsTableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    var mapView = GMSMapView()
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    
    var magnitudeCell: AddMonitoredRegionCell?
    var distanceCell: AddMonitoredRegionCell?
    
    var coordinatesToBeSent: CLLocationCoordinate2D?
    var didDropAPin: Bool = false
    
    var name: String?
    var didEnterName: Bool = false
    
    var didTapClose: (()  -> ())?
    
    @objc func didTapCloseFunc(){
        didTapClose?()
    }
    
    var didTapApply: ((String, [Double], Float, Double)  -> ())?
    
    @objc func didTapApplyFunc() {
        let magnitude = Float(magnitudeCell!.stepperControlMagnitude.value)
        let distance = distanceCell!.stepperControlDistance.value
        
        didTapApply?(name!, [Double(coordinatesToBeSent!.latitude), Double(coordinatesToBeSent!.longitude)], magnitude, distance)
    }
    
    struct Cells {
        static let addMonitoredRegionCell = "AddMonitoredRegionCell"
    }
    
    func setup() {
        addSubview(addMonitoredEventsTableView)
        configureSettingsTableView()
        setupSearchBar()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
    private func configureSettingsTableView() {
        setAddMonitoredRegionViewDelegates()
        addMonitoredEventsTableView.backgroundColor = .systemGroupedBackground
        addMonitoredEventsTableView.separatorColor = .separator
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
        backgroundColor = .systemGroupedBackground
        navigationItem?.title = "Add Monitored Place"
        navigationItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseFunc))
        navigationItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapApplyFunc))
        navigationItem?.rightBarButtonItem?.isEnabled = false
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.label] // cambia aspetto del titolo
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label] // cambia aspetto del titolo (con prefersLargeTitles = true)
            // navigationBar?.tintColor = .systemBlue // tintColor changes the color of the UIBarButtonItem
            navBarAppearance.backgroundColor = .secondarySystemBackground // cambia il colore dello sfondo della navigation bar
            // navigationBar?.isTranslucent = false // da provare la differenza tra true/false solo con colori vivi
            navigationBar?.standardAppearance = navBarAppearance
            navigationBar?.scrollEdgeAppearance = navBarAppearance
        } else {
            // navigationBar?.tintColor = .systemBlue
            navigationBar?.barTintColor = .secondarySystemBackground
            // navigationBar?.isTranslucent = false
        }
        resultsViewController?.tableCellBackgroundColor = .systemBackground
    }
    
    func update(oldModel: AddMonitoredPlaceViewModel?) {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addMonitoredEventsTableView.translatesAutoresizingMaskIntoConstraints = false
        addMonitoredEventsTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        addMonitoredEventsTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        addMonitoredEventsTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        addMonitoredEventsTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
}

extension AddMonitoredPlaceView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            didEnterName = false
            navigationItem?.rightBarButtonItem?.isEnabled = false
        } else {
            didEnterName = true
            name = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if didDropAPin {
                navigationItem?.rightBarButtonItem?.isEnabled = true
            }
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        didEnterName = false
        navigationItem?.rightBarButtonItem?.isEnabled = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension AddMonitoredPlaceView: GMSAutocompleteResultsViewControllerDelegate, GMSMapViewDelegate {
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
        let newLocation = GMSCameraPosition(target: place.coordinate, zoom: 12, bearing: 0, viewingAngle: 0)
        mapView.animate(to: newLocation)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
        
        coordinatesToBeSent = coordinate
        didDropAPin = true
        if didEnterName {
            navigationItem?.rightBarButtonItem?.isEnabled = true
        }
    }
    
}

extension AddMonitoredPlaceView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = AddMonitoredPlaceOption(rawValue: indexPath.row) else { return 0.0 }
        switch option {
        case .map: return 380
        default: return 48
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = AddMonitoredPlaceOption(rawValue: indexPath.row) else { return 0.0 }
        switch option {
        case .map: return 380
        default: return 48
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return AddMonitoredRegionSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddMonitoredPlaceOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return AddMonitoredRegionSection(rawValue: section)?.description
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Tap and hold on the map to drop a pin"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addMonitoredEventsTableView.dequeueReusableCell(withIdentifier: Cells.addMonitoredRegionCell, for: indexPath) as! AddMonitoredRegionCell
        guard let section = AddMonitoredRegionSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .MonitoredPlace:
            let type = AddMonitoredPlaceOption(rawValue: indexPath.row)
            cell.sectionType = type
            if cell.sectionType!.containsNameTextField {
                cell.nameTextField.delegate = self
            }
            else if cell.sectionType!.containsStepperMagnitude {
                magnitudeCell = cell
            }
            else if cell.sectionType!.containsStepperDistance {
                distanceCell = cell
            }
            else {
                mapView = cell.mapView
                cell.mapView.delegate = self
            }
        }
        return cell
    }
    
}
