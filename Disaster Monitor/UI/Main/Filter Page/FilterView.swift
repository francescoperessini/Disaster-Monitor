//
//  FilterView.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 25/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura

// MARK: - ViewModel
struct FilterViewModel: ViewModelWithState {
    var state: AppState
    init?(state: AppState) {
        self.state = state
    }
}

// MARK: - View
class FilterView: UIView, ViewControllerModellableView {
    
    var filterTableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    var didTapClose: (() -> ())?
    
    @objc func didTapCloseFunc() {
        didTapClose?()
    }
    
    // MARK: - Magnitude Section
    var sliderValue: Float?
    var didSlide: ((Float) -> ())?
    
    // MARK: - Time Period Section
    var segmentedControlValue: String?
    var didTapSegmented: ((Int) -> ())?
    
    // MARK: - Data Source Section
    var switchValues: [String: Bool]?
    var didTapSwitchINGV: ((Bool) -> ())?
    var didTapSwitchUSGS: ((Bool) -> ())?
    
    struct Cells {
        static let filterTableViewCell = "filterCell"
    }
    
    func setup() {
        addSubview(filterTableView)
        configureFilterTableView()
    }
    
    private func configureFilterTableView() {
        setFilterTableViewDelegates()
        filterTableView.backgroundColor = .systemGroupedBackground
        filterTableView.separatorColor = .separator
        filterTableView.isScrollEnabled = false
        filterTableView.register(FilterTableViewCell.self, forCellReuseIdentifier: Cells.filterTableViewCell)
    }
    
    private func setFilterTableViewDelegates() {
        filterTableView.delegate = self
        filterTableView.dataSource = self
    }
    
    func style() {
        backgroundColor = .systemGroupedBackground
        navigationItem?.title = "Filters"
        navigationItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapCloseFunc))
        
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
    
    func update(oldModel: FilterViewModel?) {
        guard let model = self.model else { return }
        
        sliderValue = model.state.magnitudeFilteringValue
        segmentedControlValue = String(model.state.displayedDays)
        switchValues = model.state.dataSources
        
        navigationBar?.tintColor = model.state.customColor.getColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        filterTableView.translatesAutoresizingMaskIntoConstraints = false
        filterTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        filterTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        filterTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        filterTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
}

extension FilterView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = FilterSection(rawValue: indexPath.section) else { return 0.0 }
        switch section {
        case .Magnitude:
            return 80
        case .Period:
            return 80
        case .Source:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = FilterSection(rawValue: indexPath.section) else { return 0.0 }
        switch section {
        case .Magnitude:
            return 80
        case .Period:
            return 80
        case .Source:
            return UITableView.automaticDimension
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return FilterSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = FilterSection(rawValue: section) else { return 0 }
        switch section {
        case .Magnitude:
            return MagnitudeOption.allCases.count
        case .Period:
            return PeriodOption.allCases.count
        case .Source:
            return SourceOption.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return FilterSection(rawValue: section)?.description
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let section = FilterSection(rawValue: section) else { return "" }
        switch section {
        case .Magnitude:
            return "Filter events by magnitude\nEarthquake magnitude is a measure of the size of an earthquake at its source"
        case .Period:
            return "Filter events by time period"
        case .Source:
            return "Filter events by data source"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = filterTableView.dequeueReusableCell(withIdentifier: Cells.filterTableViewCell, for: indexPath) as! FilterTableViewCell
        guard let section = FilterSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .Magnitude:
            let magnitude = MagnitudeOption(rawValue: indexPath.row)
            cell.filterSectionType = magnitude
            if cell.filterSectionType!.containsMagnitudeSlider {
                cell.didSlide = self.didSlide
                cell.setupMagnitudeSection(value: sliderValue ?? 0.0)
            }
        case .Period:
            let period = PeriodOption(rawValue: indexPath.row)
            cell.filterSectionType = period
            if cell.filterSectionType!.containsTimePeriodSegmentedControl {
                cell.didTapSegmented = self.didTapSegmented
                cell.setupTimePeriodSection(period: segmentedControlValue ?? "")
            }
        case .Source:
            let source = SourceOption(rawValue: indexPath.row)
            cell.filterSectionType = source
            if cell.filterSectionType!.containsINGVSwitch {
                cell.didTapSwitchINGV = self.didTapSwitchINGV
                cell.setupINGVSwitch(value: switchValues!["INGV"] ?? true)
            }
            if cell.filterSectionType!.containsUSGSSwitch {
                cell.didTapSwitchUSGS = self.didTapSwitchUSGS
                cell.setupUSGSSwitch(value: switchValues!["USGS"] ?? true)
            }
        }
        return cell
    }
    
}
