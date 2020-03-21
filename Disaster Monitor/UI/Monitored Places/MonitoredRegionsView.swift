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
    var didTapClose: (() -> ())?
    var didTapAdd: (() -> ())?
    var didRemoveElement: ((Int) -> ())?
    
    var monitoredEventsTableView = UITableView(frame: CGRect.zero, style: .grouped)
    var monitoredRegion: [Region] = []
    struct Cells {
        static let monitoredRegionCell = "monitoredRegionCell"
    }

    func setup() {
        self.backgroundColor = .systemBackground
        self.addSubview(monitoredEventsTableView)
        configureMonitoredRegionTableView()
        setMonitoredRegionViewDelegates()
    }
    
    func setMonitoredRegionViewDelegates() {
        monitoredEventsTableView.delegate = self
        monitoredEventsTableView.dataSource = self
    }

    func style() {
        navigationItem?.title = "Monitored Regions"
        navigationItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddFunc))
        
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

    func update(oldModel: MonitoredRegionsViewModel?) {
        guard let model = self.model else { return }
        monitoredRegion = model.state.regions
        DispatchQueue.main.async {
            self.monitoredEventsTableView.reloadData()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        monitoredEventsTableView.translatesAutoresizingMaskIntoConstraints = false
        monitoredEventsTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        monitoredEventsTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        monitoredEventsTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        monitoredEventsTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    private func configureMonitoredRegionTableView() {
        monitoredEventsTableView.rowHeight = 65
        monitoredEventsTableView.register(MonitoredRegionViewCell.self, forCellReuseIdentifier: Cells.monitoredRegionCell)
    }
    
    @objc func didTapAddFunc(){
        didTapAdd?()

    }
    
    @objc func didTapCloseFunc(){
        didTapClose?()
    }
}

extension MonitoredRegionsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = MonitoredRegionSection(rawValue: indexPath.section) else { return 0.0 }
        switch section {
        case .MonitoredRegion: return 65
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = MonitoredRegionSection(rawValue: indexPath.section) else { return 0.0 }
        switch section {
        case .MonitoredRegion: return 65
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MonitoredRegionSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.monitoredRegion.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return MonitoredRegionSection(rawValue: section)?.description
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let section = MonitoredRegionSection(rawValue: section) else { return "" }
        switch section {
        case .MonitoredRegion:
            return "Description"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = monitoredEventsTableView.dequeueReusableCell(withIdentifier: Cells.monitoredRegionCell, for: indexPath) as! MonitoredRegionViewCell
        cell.setupCell(region: monitoredRegion[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            self.monitoredRegion.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            didRemoveElement?(indexPath.row)
        }
    }
    
}
