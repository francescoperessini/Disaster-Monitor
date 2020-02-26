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
    var name: String
    var surname: String
    init?(state: AppState) {
        self.name = "\(state.name)"
        self.surname = "\(state.surname)"
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
        settingsTableView.rowHeight = 100
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemGray6
        
        let title = UILabel()
        title.font = UIFont(name: "Futura", size: 20)
        title.textColor = .black
        title.text = "Test"
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
        
        switch indexPath.section {
        case 0:
            cell.backgroundColor = .red
        case 1:
            cell.backgroundColor = .blue
        default:
            break
        }
        
        return cell
        
    }
    
}
