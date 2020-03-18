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
    
    var didTapStylingColor: ((Color) -> ())?
    var didTapSwitch: ((Bool) -> ())?

    var customColor: Color?
    var debugMode: Bool?
    
    @objc func didTapEditMessageFunc() {
        didTapEditMessage?()
    }
    
    struct Cells {
        static let settingsTableViewCell = "settingsCell"
    }
    
    func setup() {
        self.addSubview(settingsTableView)
        configureSettingsTableView()
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
        case .Privacy:
            return PrivacyOption.allCases.count
        case .Styling:
            return StylingOption.allCases.count
        case .Debug:
            return DebugOption.allCases.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemGray6
        
        let title = UILabel()
        //title.font = UIFont(name: "Futura", size: 20)
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textColor = .label
        title.text = SettingsSection(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let section = SettingsSection(rawValue: section) else { return "" }
        
        switch section {
        case .AboutUs:
            return "We are two CSE Students at Polimi, Francesco and Stefano"
        case .Message:
            return "Safe message is the message you can share in Map Page"
        case .Privacy:
            return "TBD"
        case .Styling:
            return "Customize here your experience"
        case .DataSource:
            return "We are currently using INGV and USGS Api Endpoints"
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
            // cell.textLabel?.text = message?.description
            cell.sectionType = message
        case .Privacy:
            let privacy = PrivacyOption(rawValue: indexPath.row)
            cell.sectionType = privacy
        case .Styling:
            let style = StylingOption(rawValue: indexPath.row)
            cell.sectionType = style
            if cell.sectionType!.containsSegmenteColor {
                cell.didTapStylingColor = self.didTapStylingColor
                cell.setupColorCell(color: self.customColor!)
            }
        case .AboutUs:
            let aboutUs = AboutUsOption(rawValue: indexPath.row)
            cell.sectionType = aboutUs
            
        case .DataSource:
            let dataSource = DataSourceOption(rawValue: indexPath.row)
            cell.sectionType = dataSource
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
        case .Privacy: break
        case .Styling: break
        case .AboutUs: break
        case .DataSource: break
        case .Debug: break
        }
        settingsTableView.deselectRow(at: settingsTableView.indexPathForSelectedRow!, animated: true)
    }
    
}
