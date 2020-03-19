//
//  MainEventsView.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 28/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura

// MARK: - ViewModel
struct MainEventsViewModel: ViewModelWithState {
    var state: AppState
    init?(state: AppState) {
        self.state = state
    }
}

// MARK: - View
class MainEventsView: UIView, ViewControllerModellableView{
    
    var mainEventsTableView = UITableView()
    var events: [Event] = []
    var past24Events: [Event] = []
    var past48Events: [Event] = []
    var past72Events: [Event] = []
    var past96Events: [Event] = []
    var previousDaysEvents: [Event] = []
    
    var filteringValue: Float = 0
    var filteringDay: Int = 0
    var dataSources: [String: Bool] = [:]
    var refreshControl = UIRefreshControl()
    var isSearching = true
    
    var didTapFilter: (() -> ())?
    var didTapSearch: (() -> ())?
    var didTapEvent: ((String) -> ())?
    var didPullRefreshControl: (() -> ())?
    var color: Color?
    var searchController = UISearchController(searchResultsController: nil)
    var end: ((String) -> ())?
    struct Cells {
        static let mainEventsTableViewCell = "mainCell"
    }
    
    func setup() {
        self.addSubview(mainEventsTableView)
        configureMainEventsTableView()
        setupRefreshControl()
    }
    
    func configureMainEventsTableView() {
        setMainEventsTableViewDelegates()
        mainEventsTableView.rowHeight = 63
        mainEventsTableView.register(MainEventsTableViewCell.self, forCellReuseIdentifier: Cells.mainEventsTableViewCell)
    }
    
    func setMainEventsTableViewDelegates() {
        mainEventsTableView.delegate = self
        mainEventsTableView.dataSource = self
    }

    func style() {
        backgroundColor = .systemBackground
        navigationBar?.prefersLargeTitles = true
        navigationItem?.title = "Main Events"
        navigationItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(didTapFilterFunc))
        navigationItem?.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(didTapSearchFunc))
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            //navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.label, .font: UIFont(name: "Futura", size: 30)!] // cambia aspetto del titolo
            //navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label, .font: UIFont(name: "Futura", size: 30)!] // cambia aspetto del titolo (con prefersLargeTitles = true)
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.label] // cambia aspetto del titolo
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label] // cambia aspetto del titolo (con prefersLargeTitles = true)
            //navigationBar?.tintColor = .systemBlue // tintColor changes the color of the UIBarButtonItem
            navBarAppearance.backgroundColor = .systemGray6 // cambia il colore dello sfondo della navigation bar
            // navigationBar?.isTranslucent = false // da provare la differenza tra true/false solo con colori vivi􀊫
            navigationBar?.standardAppearance = navBarAppearance
            navigationBar?.scrollEdgeAppearance = navBarAppearance
        } else {
            navigationBar?.tintColor = .systemBlue
            navigationBar?.barTintColor = .systemGray6
            // navigationBar?.isTranslucent = false
        }
    }

    func update(oldModel: MainViewModel?) {
        guard let model = self.model else { return }
        events = model.state.events
        filteringValue = model.state.filteringValue
        filteringDay = model.state.segmentedDays
        dataSources = model.state.dataSources
        dataSources = dataSources.filter{$0.value == true}
        let tmp = dataSources.keys
        let str = model.state.searchString
        events = events.filter{ $0.magnitudo > self.filteringValue && $0.daysAgo < self.filteringDay && tmp.contains($0.dataSource)}
        
        /*if str != "" {
            events = events.filter{$0.name.contains(str)}
        }*/
        past24Events = events.filter{$0.daysAgo == 0}
        past48Events = events.filter{$0.daysAgo == 1}
        past72Events = events.filter{$0.daysAgo == 2}
        past96Events = events.filter{$0.daysAgo == 3}
        previousDaysEvents = events.filter{$0.daysAgo >= 4}
        color = model.state.customColor
        navigationBar?.tintColor = model.state.customColor.getColor()
        
        DispatchQueue.main.async {
            self.mainEventsTableView.reloadData()
        }
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        mainEventsTableView.pin.top().left().right().bottom()
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(didPullRefreshControlFunc), for: .valueChanged)
        mainEventsTableView.refreshControl = refreshControl
    }
    
    @objc func didTapFilterFunc() {
        didTapFilter?()
    }
       
    @objc func didTapEventFunc(id: String) {
        didTapEvent?(id)
    }
    
    @objc func didPullRefreshControlFunc() {
        didPullRefreshControl?()
    }
    
    @objc func didTapSearchFunc() {
        // Create the search controller and specify that it should present its results in this same view
        searchController = UISearchController(searchResultsController: nil)

        // Set any properties (in this case, don't hide the nav bar and don't show the emoji keyboard option)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.keyboardType = UIKeyboardType.asciiCapable

        // Make this class the delegate and present the search
        self.searchController.searchBar.delegate = self
        didTapSearch?()
    }
}

extension MainEventsView: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MainEventsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = MainEventsSection(rawValue: section) else { return 0 }
        
        switch section {
        case .Past24:
            return past24Events.count
        case .Past48:
            return past48Events.count
        case .Past72:
            return past72Events.count
        case .Past96:
            return past96Events.count
        case .PreviousDays:
            return previousDaysEvents.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemGray6

        let clockImage = UIImage(systemName: "clock")
        let clockImageView = UIImageView(image: clockImage!.withRenderingMode(.alwaysTemplate))
        clockImageView.tintColor = .label

        let title = UILabel()
        //title.font = UIFont(name: "Futura", size: 20)
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textColor = .label
        title.text = MainEventsSection(rawValue: section)?.description
        
        view.addSubview(title)
        view.addSubview(clockImageView)
        clockImageView.translatesAutoresizingMaskIntoConstraints = false
        clockImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        clockImageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: clockImageView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: clockImageView.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainEventsTableView.dequeueReusableCell(withIdentifier: Cells.mainEventsTableViewCell, for: indexPath) as! MainEventsTableViewCell
        let event: Event?
        
        switch indexPath.section {
            case 0: event = past24Events[indexPath.row]
            case 1: event = past48Events[indexPath.row]
            case 2: event = past72Events[indexPath.row]
            case 3: event = past96Events[indexPath.row]
            default: event = previousDaysEvents[indexPath.row]
        }
        
        cell.setupCell(event: event!, color: color!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = MainEventsSection(rawValue: indexPath.section) else { return }
        switch section {
        case .Past24:
            didTapEventFunc(id: past24Events[indexPath.row].id)
        case .Past48:
            didTapEventFunc(id: past48Events[indexPath.row].id)
        case .Past72:
            didTapEventFunc(id: past72Events[indexPath.row].id)
        case .Past96:
            didTapEventFunc(id: past96Events[indexPath.row].id)
        case .PreviousDays:
            didTapEventFunc(id: previousDaysEvents[indexPath.row].id)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            self.endEditing(true)
            end?("")
        }else{
            isSearching = true
            end?(searchBar.text!)
        }
    }
}
