//
//  SettingsView.swift
//  Disaster Monitor
//
//  Created by Francesco Peressini on 19/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import Foundation
import Katana
import Tempura
import PinLayout

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
    var didTapEditMonitoredLocations: (() -> ())?
    
    var didTapStylingColor: ((Color) -> ())?
    var didTapSwitch: ((Bool) -> ())?
    var didTapNotificationSwitch: ((Bool) -> ())?
    
    var customColor: Color?
    var debugMode: Bool?
    
    @objc func didTapEditMessageFunc() {
        didTapEditMessage?()
    }
    
    @objc func didTapEditMonitoredLocationsFunc() {
        didTapEditMonitoredLocations?()
    }
    
    struct Cells {
        static let settingsTableViewCell = "settingsCell"
    }
    
    func setup() {
        self.addSubview(settingsTableView)
        configureSettingsTableView()
        setTableFooterView()
    }
    
    func style() {
        backgroundColor = .white
        navigationBar?.prefersLargeTitles = true
        navigationItem?.title = "Settings"
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.label] // cambia aspetto del titolo
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label] // cambia aspetto del titolo (con prefersLargeTitles = true)
            navigationBar?.tintColor = .black // tintColor changes the color of the UIBarButtonItem
            navBarAppearance.backgroundColor = .systemGray6 // cambia il colore dello sfondo della navigation bar
            // navigationBar?.isTranslucent = false // da provare la differenza tra true/false solo con colori vivi
            navigationBar?.standardAppearance = navBarAppearance
            navigationBar?.scrollEdgeAppearance = navBarAppearance
        } else {
            navigationBar?.tintColor = .black
            navigationBar?.barTintColor = .systemGray6
            // navigationBar?.isTranslucent = false
        }
    }

    func update(oldModel: MainViewModel?) {
        self.customColor = model?.state.customColor
        self.debugMode = model?.state.debugMode
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        settingsTableView.pin.top().left().right().bottom()
    }
    
    private func configureSettingsTableView() {
           setSettingsTableViewDelegates()
           settingsTableView.rowHeight = 60
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
        titleLabel.textColor = .systemGray
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
    
}

extension SettingsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return 0.0 }

        switch section {
        default: return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return 0.0 }

        switch section {
        default: return UITableView.automaticDimension
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
            return NotificationsOption.allCases.count
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
            return "Safe message is the message you can share in Map Page"
        case .Notifications:
            return "Here you can turn on or off the notifications and setup yuor monitored places "
        case .Styling:
            return "Customize here your experience"
        case .Debug:
            return "Activate here debug mode"
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
            let privacy = NotificationsOption(rawValue: indexPath.row)
            cell.sectionType = privacy
            if cell.sectionType!.containsNotificationSwitch {
                cell.didTapNotificationSwitch = self.didTapNotificationSwitch
            }
        case .Styling:
            let style = StylingOption(rawValue: indexPath.row)
            cell.sectionType = style
            if cell.sectionType!.containsSegmenteColor {
                cell.didTapStylingColor = self.didTapStylingColor
                cell.setupColorCell(color: self.customColor!)
            }
        case .Debug:
            let debug = DebugOption(rawValue: indexPath.row)
            cell.sectionType = debug
            if cell.sectionType!.containsDebugModeSwitch {
                cell.didTapSwitch = self.didTapSwitch
                cell.setupDebugSwitch(value: self.debugMode!)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .Message:
            if indexPath.row == 0 {
                didTapEditMessageFunc()
            }
        case .Notifications:
            if indexPath.row == 1 {
                didTapEditMonitoredLocationsFunc()
            }
        case .Styling: break
        case .Debug: break
        }
    }
    
}
