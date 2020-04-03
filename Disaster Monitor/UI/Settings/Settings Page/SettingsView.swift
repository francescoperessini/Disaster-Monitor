//
//  SettingsView.swift
//  Disaster Monitor
//
//  Created by Francesco Peressini on 19/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import Tempura

// MARK: - ViewModel
struct SettingsViewModel: ViewModelWithState {
    var state: AppState
    init?(state: AppState) {
        self.state = state
    }
}

// MARK: - View
class SettingsView: UIView, ViewControllerModellableView {

    var settingsTableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    var didTapEditMessage: (() -> ())?
    
    @objc func didTapEditMessageFunc() {
        didTapEditMessage?()
    }
    
    var isNotficiationEnabled: Bool?
    var didTapNotificationSwitch: ((Bool) -> ())?
    
    var didTapMonitoredPlaces: (() -> ())?
    
    @objc func didTapMonitoredPlacesFunc() {
        didTapMonitoredPlaces?()
    }
    
    var customColor: Color?
    var didTapStylingColor: ((Color) -> ())?
    
    var debugMode: Bool?
    var didTapDebugSwitch: ((Bool) -> ())?
    
    struct Cells {
        static let settingsTableViewCell = "settingsCell"
    }
    
    func setup() {
        addSubview(settingsTableView)
        configureSettingsTableView()
        setTableFooterView()
    }
    
    private func configureSettingsTableView() {
        setSettingsTableViewDelegates()
        settingsTableView.backgroundColor = .systemGroupedBackground
        settingsTableView.separatorColor = .separator
        settingsTableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: Cells.settingsTableViewCell)
    }

    private func setSettingsTableViewDelegates() {
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
    }
    
    private func setTableFooterView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: settingsTableView.frame.width, height: 140))

        customView.backgroundColor = .clear
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .secondaryLabel
        let dataSources = "Data Sources\nINGV: Istituto Nazionale di Geofisica e Vulcanologia\nUSGS: United States Geological Survey\n\n"
        let aboutUs = "About Us\nWe are two CSE students @ PoliMi, Francesco and Stefano"
        titleLabel.text = dataSources + aboutUs
        customView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: customView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: customView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: customView.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: customView.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        settingsTableView.tableFooterView = customView
    }
    
    func style() {
        backgroundColor = .systemGroupedBackground
        navigationBar?.prefersLargeTitles = true
        navigationItem?.title = "Settings"
        
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

    func update(oldModel: SettingsViewModel?) {
        guard let model = self.model else { return }

        isNotficiationEnabled = model.state.isNotficiationEnabled
        customColor = model.state.customColor
        debugMode = model.state.debugMode
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
        settingsTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        settingsTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        settingsTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        settingsTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
}

extension SettingsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return 0.0 }
        switch section {
        default: return 48
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return 0.0 }
        switch section {
        default: return 48
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingsSection(rawValue: section) else { return 0 }
        switch section {
        case .Message:
            return MessageOption.allCases.count
        case .Notifications:
            return NotificationOption.allCases.count
        case .Styling:
            return StylingOption.allCases.count
        case .Debug:
            return DebugOption.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SettingsSection(rawValue: section)?.description
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let section = SettingsSection(rawValue: section) else { return "" }
        switch section {
        case .Message:
            return "Edit the Safe Message shareable from the Map Page"
        case .Notifications:
            return "Manage notifications permission and set up your Monitored Places"
        case .Styling:
            return "Customize your experience"
        case .Debug:
            return "Activate debug mode"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: Cells.settingsTableViewCell, for: indexPath) as! SettingsTableViewCell
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .Message:
            let message = MessageOption(rawValue: indexPath.row)
            cell.sectionType = message
        case .Notifications:
            let notifications = NotificationOption(rawValue: indexPath.row)
            cell.sectionType = notifications
            if cell.sectionType!.containsNotificationSwitch {
                cell.selectionStyle = .none
                cell.didTapNotificationSwitch = self.didTapNotificationSwitch
                cell.setupNotificationSwitch(value: isNotficiationEnabled ?? false)
            }
            else {
                cell.accessoryType = .disclosureIndicator
            }
        case .Styling:
            let style = StylingOption(rawValue: indexPath.row)
            cell.sectionType = style
            if cell.sectionType!.containsSegmentedColor {
                cell.selectionStyle = .none
                cell.didTapStylingColor = self.didTapStylingColor
                cell.setupColorCell(color: customColor ?? Color(name: colors.blue))
            }
        case .Debug:
            let debug = DebugOption(rawValue: indexPath.row)
            cell.sectionType = debug
            if cell.sectionType!.containsDebugModeSwitch {
                cell.selectionStyle = .none
                cell.didTapDebugSwitch = self.didTapDebugSwitch
                cell.setupDebugSwitch(value: debugMode ?? false)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
        switch section {
        case .Message:
            didTapEditMessageFunc()
        case .Notifications:
            if indexPath.row == 0 {
                break
            }
            if indexPath.row == 1 {
                didTapMonitoredPlacesFunc()
            }
        case .Styling:
            break
        case .Debug:
            break
        }
        settingsTableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
}
