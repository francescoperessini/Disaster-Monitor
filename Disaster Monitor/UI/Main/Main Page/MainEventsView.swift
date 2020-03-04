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
        events.sorted(by: {$0.daysAgo < $1.daysAgo})
        filteringValue = model.state.filteringValue ?? 0
        filteringDay = model.state.segmentedDays
        events = events.filter{$0.magnitudo > self.filteringValue && $0.daysAgo < self.filteringDay}
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
        // refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
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
            return events.filter{$0.daysAgo == 0}.count
        case .TwoDay:
            return events.filter{$0.daysAgo == 1}.count
        case .ThreeDay:
            return events.filter{$0.daysAgo == 2}.count
        case .FourDay:
            return events.filter{$0.daysAgo == 3}.count
        case .OthersDay:
            return events.filter{$0.daysAgo > 4}.count
        }
    }
    
    //let events = model.list.filter{$0.magnitudo > model.filteringValue}.map{EventCellViewModel(id: $0.id, name: $0.name, magnitudo:$0.magnitudo, description: $0.description, coord:$0.coordinates )}
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemGray6
        
        let title = UILabel()
        title.font = UIFont(name: "Futura", size: 20)
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
        if events.count != 0 {
            let event = events[indexPath.row]
            cell.setupCell(event: event)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = MainEventsSection(rawValue: indexPath.section) else { return }
        
        switch section {
            default: didTapEventFunc(id: events[indexPath.row].id)
        }
    }
    
}
