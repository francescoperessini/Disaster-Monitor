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
    
    var addMonitoredEventsTableView = UITableView(frame: CGRect.zero, style: .grouped)
    struct Cells {
        static let addMonitoredRegionCell = "AddMonitoredRegionCell"
    }
    func setup() {
        addMonitoredEventsTableView.isScrollEnabled = false
        addSubview(addMonitoredEventsTableView)
        setupSearchBar()
        configureSettingsTableView()
    }
    
    func setAddMonitoredRegionViewDelegates() {
        addMonitoredEventsTableView.delegate = self
        addMonitoredEventsTableView.dataSource = self
    }
    
    private func configureSettingsTableView() {
           setAddMonitoredRegionViewDelegates()
           addMonitoredEventsTableView.register(AddMonitoredRegionCell.self, forCellReuseIdentifier: Cells.addMonitoredRegionCell)
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
    
    func update(oldModel: AddMonitoredPlaceViewModel?) {
        guard let model = self.model else { return }

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addMonitoredEventsTableView.pin.top().left().right().bottom()
    }
    
}

// MARK: - CLLocationManagerDelegate
extension AddMonitoredPlaceView: CLLocationManagerDelegate, GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        let newLocation = GMSCameraPosition(target: place.coordinate, zoom: 12, bearing: 0, viewingAngle: 0)
        
        //guard let mapCell = self.addMonitoredEventsTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? AddMonitoredRegionCell else {return}
        let mapCell = self.addMonitoredEventsTableView.visibleCells[2]
        
        //mapCell.mapView.animate(to: newLocation)
        //mapView.animate(to: newLocation)
    }

    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
}

extension AddMonitoredPlaceView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0 || indexPath.row == 1){
            return 60;
        }
        else {
            return 500;
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = AddMonitoredRegionSection(rawValue: indexPath.section) else { return 0.0 }
        switch section {
        case .MonitoredRegion: return 65
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("AddMonitoredRegionSection.allCases.count \(AddMonitoredRegionSection.allCases.count)")
        return AddMonitoredRegionSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddMonitoredRegionOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return AddMonitoredRegionSection(rawValue: section)?.description
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let section = AddMonitoredRegionSection(rawValue: section) else { return "" }
        switch section {
        case .MonitoredRegion:
            return "Description"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath)
        let cell = addMonitoredEventsTableView.dequeueReusableCell(withIdentifier: Cells.addMonitoredRegionCell, for: indexPath) as! AddMonitoredRegionCell
        guard let section = AddMonitoredRegionSection(rawValue: indexPath.section) else { return UITableViewCell() }
        let type = AddMonitoredRegionOption(rawValue: indexPath.row)
        cell.sectionType = type
        return cell
    }
}


