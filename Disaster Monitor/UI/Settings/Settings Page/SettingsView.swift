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
    var didTapAboutUs: (() -> ())?
    
    var didTapStylingColor: ((Color) -> ())?
    var customColor: Color?
    
    @objc func didTapEditMessageFunc() {
        didTapEditMessage?()
    }
    
    @objc func didTapAboutUsFunc() {
        didTapAboutUs?()
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
        case .AboutUs:
            return AboutUsOption.allCases.count
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
            if cell.sectionType!.containsSegmenteColor{
                cell.didTapStylingColor = self.didTapStylingColor
                cell.setupColorCell(color: self.customColor!)
            }
        case .AboutUs:
            let aboutUs = AboutUsOption(rawValue: indexPath.row)
            cell.sectionType = aboutUs
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
        case .Privacy:
            if indexPath.row == 0 {
                print("riga 0 della sezione Privacy")
            }
            else if indexPath.row == 1 {
                print("riga 1 della sezione Privacy")
            }
        case .AboutUs:
            didTapAboutUsFunc()
            
        default:
            print("ciao")
        }
        settingsTableView.deselectRow(at: settingsTableView.indexPathForSelectedRow!, animated: true)
    }
    
}

