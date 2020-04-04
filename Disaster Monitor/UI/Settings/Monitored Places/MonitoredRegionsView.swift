//
//  MonitoredRegionView.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 20/03/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura

// MARK: - ViewModel
struct MonitoredRegionsViewModel: ViewModelWithState {
    var state: AppState
    init?(state: AppState) {
        self.state = state
    }
}

// MARK: - View
class MonitoredRegionsView: UIView, ViewControllerModellableView {
    
    var monitoredPlacesTableView = UITableView(frame: CGRect.zero, style: .grouped)
    var monitoredPlaces: [Region] = []
    
    var didTapAdd: (() -> ())?
    
    @objc func didTapAddFunc() {
        didTapAdd?()
    }
    
    var didRemoveElement: ((Int) -> ())?
    
    @objc func didRemoveElementFunc(index: Int) {
        didRemoveElement?(index)
    }
    
    struct Cells {
        static let monitoredPlacesCell = "monitoredPlacesCell"
    }
    
    func setup() {
        addSubview(monitoredPlacesTableView)
        configureMonitoredPlacesTableView()
    }
    
    private func configureMonitoredPlacesTableView() {
        setMonitoredPlacesTableViewDelegates()
        monitoredPlacesTableView.backgroundColor = .systemGroupedBackground
        monitoredPlacesTableView.separatorColor = .separator
        monitoredPlacesTableView.register(MonitoredRegionViewCell.self, forCellReuseIdentifier: Cells.monitoredPlacesCell)
    }
    
    private func setMonitoredPlacesTableViewDelegates() {
        monitoredPlacesTableView.delegate = self
        monitoredPlacesTableView.dataSource = self
    }
    
    func style() {
        backgroundColor = .systemGroupedBackground
        navigationItem?.title = "Monitored Places"
        navigationItem?.largeTitleDisplayMode = .never
        navigationItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddFunc))
        
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
    }
    
    func update(oldModel: MonitoredRegionsViewModel?) {
        guard let model = self.model else { return }
        
        monitoredPlaces = model.state.regions
        DispatchQueue.main.async {
            self.monitoredPlacesTableView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        monitoredPlacesTableView.translatesAutoresizingMaskIntoConstraints = false
        monitoredPlacesTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        monitoredPlacesTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        monitoredPlacesTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        monitoredPlacesTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
}

extension MonitoredRegionsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = MonitoredRegionSection(rawValue: indexPath.section) else { return 0.0 }
        switch section {
        default: return 60
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = MonitoredRegionSection(rawValue: indexPath.section) else { return 0.0 }
        switch section {
        default: return 60
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MonitoredRegionSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if monitoredPlaces.isEmpty {
            setEmptyView(title: "You don't have any monitored region", message: "You can add one by pressing '+'")
            return 0
        }
        else {
            restore()
            return monitoredPlaces.count
        }
    }
    
    private func setEmptyView(title: String, message: String) {
        let emptyView = UIView()
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        emptyView.backgroundColor = .systemGroupedBackground
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .label
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        messageLabel.textColor = .secondaryLabel
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        titleLabel.text = title
        titleLabel.textAlignment = .center
        messageLabel.text = message
        messageLabel.textAlignment = .center
        
        monitoredPlacesTableView.backgroundView = emptyView
        monitoredPlacesTableView.separatorStyle = .none
    }
    
    private func restore() {
        monitoredPlacesTableView.backgroundView = nil
        monitoredPlacesTableView.separatorStyle = .singleLine
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if monitoredPlaces.isEmpty {
            return nil
        }
        else {
            return MonitoredRegionSection(rawValue: section)?.description
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = monitoredPlacesTableView.dequeueReusableCell(withIdentifier: Cells.monitoredPlacesCell, for: indexPath) as! MonitoredRegionViewCell
        cell.setupCell(place: monitoredPlaces[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            monitoredPlaces.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            didRemoveElementFunc(index: indexPath.row)
        }
    }
    
}
