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
class MainEventsView: UIView, ViewControllerModellableView {
    
    var mainEventsTableView = UITableView()
    var events: [Event] = []
    var todayEvents: [Event] = []
    var yesterdayEvents: [Event] = []
    var twoDaysAgoEvents: [Event] = []
    var threeDaysAgoEvents: [Event] = []
    var previousEvents: [Event] = []
    
    var filteringValue: Float = 0
    var filteringDay: Int = 0
    var refreshControl = UIRefreshControl()
    
    var didTapFilter: (() -> ())?
    var didTapEvent: ((String) -> ())?
    var didPullRefreshControl: (() -> ())?
    
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
        mainEventsTableView.rowHeight = 60
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
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            //navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.label, .font: UIFont(name: "Futura", size: 30)!] // cambia aspetto del titolo
            //navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label, .font: UIFont(name: "Futura", size: 30)!] // cambia aspetto del titolo (con prefersLargeTitles = true)
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

    func update(oldModel: MainViewModel?) {
        guard let model = self.model else { return }
        events = model.state.events
        filteringValue = model.state.filteringValue ?? 0
        filteringDay = model.state.segmentedDays
        events = events.filter{$0.magnitudo > self.filteringValue && $0.daysAgo < self.filteringDay}
        todayEvents = events.filter{$0.daysAgo == 0}
        yesterdayEvents = events.filter{$0.daysAgo == 1}
        twoDaysAgoEvents = events.filter{$0.daysAgo == 2}
        threeDaysAgoEvents = events.filter{$0.daysAgo == 3}
        previousEvents = events.filter{$0.daysAgo > 4}
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
       
}

extension MainEventsView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MainEventsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = MainEventsSection(rawValue: section) else { return 0 }
        
        switch section {
        case .OneDay:
            return todayEvents.count
        case .TwoDay:
            return yesterdayEvents.count
        case .ThreeDay:
            return twoDaysAgoEvents.count
        case .FourDay:
            return threeDaysAgoEvents.count
        case .OthersDay:
            return previousEvents.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemGray6
        
        let title = UILabel()
        //title.font = UIFont(name: "Futura", size: 20)
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textColor = .label
        title.text = MainEventsSection(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainEventsTableView.dequeueReusableCell(withIdentifier: Cells.mainEventsTableViewCell, for: indexPath) as! MainEventsTableViewCell

        switch indexPath.section {
        case 0:
            let event = todayEvents[indexPath.row]
            cell.setupCell(event: event)
        case 1:
            let event = yesterdayEvents[indexPath.row]
            cell.setupCell(event: event)
        case 2:
            let event = twoDaysAgoEvents[indexPath.row]
            cell.setupCell(event: event)
        case 3:
            let event = threeDaysAgoEvents[indexPath.row]
            cell.setupCell(event: event)
        case 4:
            let event = previousEvents[indexPath.row]
            cell.setupCell(event: event)
        default:
            print("Default case")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = MainEventsSection(rawValue: indexPath.section) else { return }
                
        switch section {
        case .OneDay:
            didTapEventFunc(id: todayEvents[indexPath.row].id)
        case .TwoDay:
            didTapEventFunc(id: yesterdayEvents[indexPath.row].id)
        case .ThreeDay:
            didTapEventFunc(id: twoDaysAgoEvents[indexPath.row].id)
        case .FourDay:
            didTapEventFunc(id: threeDaysAgoEvents[indexPath.row].id)
        case .OthersDay:
            didTapEventFunc(id: previousEvents[indexPath.row].id)
        }
    }
    
}

enum Screen: String {
    case home
}
