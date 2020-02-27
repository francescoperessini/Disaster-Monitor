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


// MARK: - ViewModel
struct SettingsViewModel: ViewModelWithState {
    var state: AppState
    init?(state: AppState) {
        self.state = state
    }
}

// MARK: - View
class SettingsView: UIView, ViewControllerModellableView {

    var settingsTableView = UITableView()
    
    struct Cells {
        static let settingsTableViewCell = "settingsCell"
    }
    
    func setup() {
        self.addSubview(settingsTableView)
        configureSettingsTableView()
    }
    
    func configureSettingsTableView() {
        setSettingsTableViewDelegates()
        settingsTableView.rowHeight = 60
        settingsTableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: Cells.settingsTableViewCell)
    }
    
    func setSettingsTableViewDelegates() {
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
    }

    func style() {
    }

    func update(oldModel: MainViewModel?) {
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        settingsTableView.pin.top().left().right().bottom().marginTop(0)
    }
    
}

extension SettingsView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        guard let section = SettingsSection(rawValue: section) else {
            return 0
        }
        
        switch section {
        case .Message:
            return MessageOption.allCases.count
        case .Privacy:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemGray6
        
        let title = UILabel()
        title.font = UIFont(name: "Futura", size: 20)
        title.textColor = .black
        title.text = SettingsSection(rawValue: section)?.description
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
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: Cells.settingsTableViewCell, for: indexPath) as! SettingsTableViewCell
        
        guard let section = SettingsSection(rawValue: indexPath.section) else {
                 return UITableViewCell()
             }
        
        switch section {
        case .Message:
            let message = MessageOption(rawValue: indexPath.row)
            cell.textLabel?.text = message?.description
        case .Privacy:
            cell.textLabel?.text = "test"
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .Message:
            if indexPath.row == 0 {
                print("riga 0 della sezione Message")
            }
        case .Privacy:
            if indexPath.row == 0 {
                print("riga 0 della sezione Privacy")
            }
            else if indexPath.row == 1 {
                print("riga 1 della sezione Privacy")
            }
        }
        
    }
    
}
