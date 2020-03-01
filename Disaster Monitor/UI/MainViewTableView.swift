//
//  MainViewTableView.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 28/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Foundation
import Katana
import Tempura

// MARK: - ViewModel
struct MainViewTableViewModel: ViewModelWithState {
    var state: AppState
    init?(state: AppState) {
        self.state = state
    }
}

// MARK: - View
class MainViewTableView: UIView, ViewControllerModellableView {
    
    var mainViewTableView = UITableView()
    var events: [Event] = []
    var filteringValue: Float = 0
    
    var didTapFilter: (() -> ())?
    var didTapEvent: ((String) -> ())?
    
    struct Cells {
        static let mainViewTableViewCell = "mainCell"
    }
    
    func setup() {
        self.addSubview(mainViewTableView)
        configureSettingsTableView()
    }
    
    func configureSettingsTableView() {
        setSettingsTableViewDelegates()
        mainViewTableView.rowHeight = 60
        mainViewTableView.register(MainTableViewCell.self, forCellReuseIdentifier: Cells.mainViewTableViewCell)
    }
    
    func setSettingsTableViewDelegates() {
        mainViewTableView.delegate = self
        mainViewTableView.dataSource = self
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
        filteringValue = model.state.filteringValue
        events = events.filter{$0.magnitudo > self.filteringValue}
        DispatchQueue.main.async {
           self.mainViewTableView.reloadData()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        mainViewTableView.pin.top().left().right().bottom()
    }
    
    @objc func didTapFilterFunc() {
           didTapFilter?()
    }
       
    @objc func didTapEventFunc(id: String) {
           didTapEvent?(id)
    }
       
}

extension MainViewTableView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MainSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = MainSection(rawValue: section) else {
            return 0
        }
        
        switch section {
        case .Event:
            return events.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemGray6
        
        let title = UILabel()
        title.font = UIFont(name: "Futura", size: 20)
        title.textColor = .label
        title.text = MainSection(rawValue: section)?.description
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
        let cell = mainViewTableView.dequeueReusableCell(withIdentifier: Cells.mainViewTableViewCell, for: indexPath) as! MainTableViewCell
        if events.count != 0{
            
            let event = events[indexPath.row]
            cell.setupCell(event: event)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = MainSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .Event:
            didTapEventFunc(id: events[indexPath.row].id)
            
        }
    }
}
