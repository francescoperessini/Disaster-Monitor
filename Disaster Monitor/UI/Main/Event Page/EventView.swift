//
//  EventView.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 25/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura
import GoogleMaps

// MARK: - ViewModel
struct EventViewModel: ViewModelWithLocalState {
    var event: Event?
    
    init?(state: AppState?, localState: EventControllerLocalState) {
        self.event = state?.events.first(where:{$0.id == localState.id})
    }
}

// MARK: - View
class EventView: UIView, ViewControllerModellableView {
    
    let mainVStackView = UIStackView()
    
    let infoVStackView = UIStackView()
    var placeLabel = UILabel()
    var hStackView = UIStackView()
    var firstColumnVStackView = UIStackView()
    var dateImage = UIImageView(image: UIImage(systemName: "clock")!.withRenderingMode(.alwaysTemplate))
    var dateLabel = UILabel()
    var coordinatesImage = UIImageView(image: UIImage(systemName: "mappin")!.withRenderingMode(.alwaysTemplate))
    var coordinatesLabel = UILabel()
    var secondColumnVStackView = UIStackView()
    var magnitudeImage = UIImageView(image: UIImage(systemName: "waveform.path.ecg")!.withRenderingMode(.alwaysTemplate))
    var magnitudeLabel = UILabel()
    var depthImage = UIImageView(image: UIImage(systemName: "arrow.down.circle")!.withRenderingMode(.alwaysTemplate))
    var depthLabel = UILabel()
    
    var mapView = GMSMapView()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
        
    func setup() {
        addSubview(mainVStackView)
        setupMainVStackView()
        
        setupFirstColumnVStackView()
        setupSecondColumnVStackView()
        setupHStackView()
        setupInfoVStackView()
        
        setupMapView()
    }
    
    private func setupMainVStackView() {
        mainVStackView.axis = .vertical
        mainVStackView.distribution = .fill
        mainVStackView.alignment = .fill
        mainVStackView.spacing = 0
        
        mainVStackView.addArrangedSubview(infoVStackView)
        mainVStackView.addArrangedSubview(mapView)
    }
    
    private func setupInfoVStackView() {
        infoVStackView.axis = .vertical
        infoVStackView.distribution = .fill
        infoVStackView.alignment = .fill
        infoVStackView.spacing = 5.0
        
        infoVStackView.addArrangedSubview(placeLabel)
        infoVStackView.addArrangedSubview(hStackView)
    }
    
    private func setupHStackView() {
        hStackView.axis = .horizontal
        hStackView.distribution = .fill
        hStackView.alignment = .fill
        hStackView.spacing = 5.0
        
        hStackView.addArrangedSubview(firstColumnVStackView)
        hStackView.addArrangedSubview(secondColumnVStackView)
    }
    
    private func setupFirstColumnVStackView() {
        firstColumnVStackView.axis = .vertical
        firstColumnVStackView.distribution = .equalSpacing
        firstColumnVStackView.alignment = .center
        firstColumnVStackView.spacing = 5.0
        
        firstColumnVStackView.addArrangedSubview(dateImage)
        firstColumnVStackView.addArrangedSubview(dateLabel)
        firstColumnVStackView.addArrangedSubview(coordinatesImage)
        firstColumnVStackView.addArrangedSubview(coordinatesLabel)
    }
    
    private func setupSecondColumnVStackView() {
        secondColumnVStackView.axis = .vertical
        secondColumnVStackView.distribution = .equalSpacing
        secondColumnVStackView.alignment = .center
        secondColumnVStackView.spacing = 5.0
        
        secondColumnVStackView.addArrangedSubview(magnitudeImage)
        secondColumnVStackView.addArrangedSubview(magnitudeLabel)
        secondColumnVStackView.addArrangedSubview(depthImage)
        secondColumnVStackView.addArrangedSubview(depthLabel)
    }
    
    private func setupMapView() {
        // compassButton displays only when map is NOT in the north direction
        mapView.settings.compassButton = true
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.tiltGestures = true
    }
    
    func style() {
        backgroundColor = .systemGray6
        navigationItem?.largeTitleDisplayMode = .never
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
        placeLabelStyle()
        dateImageStyle()
        dateLabelStyle()
        coordinatesImageStyle()
        coordinatesLabelStyle()
        magnitudeImageStyle()
        magnitudeLabelStyle()
        depthImageStyle()
        depthLabelStyle()
    }
    
    private func placeLabelStyle() {
        placeLabel.textAlignment = .center
        placeLabel.font = UIFont.systemFont(ofSize: 20)
        placeLabel.textColor = .label
    }
    
    private func dateImageStyle() {
        dateImage.tintColor = .label
    }
    
    private func dateLabelStyle() {
        dateLabel.font = UIFont.systemFont(ofSize: 18)
        dateLabel.textColor = .label
    }
    
    private func coordinatesImageStyle() {
        coordinatesImage.tintColor = .label
    }
    
    private func coordinatesLabelStyle() {
        coordinatesLabel.font = UIFont.systemFont(ofSize: 18)
        coordinatesLabel.textColor = .label
    }
    
    private func magnitudeImageStyle() {
        magnitudeImage.tintColor = .label
    }
    
    private func magnitudeLabelStyle() {
        magnitudeLabel.font = UIFont.systemFont(ofSize: 18)
        magnitudeLabel.textColor = .label
    }
    
    private func depthImageStyle() {
        depthImage.tintColor = .label
    }
    
    private func depthLabelStyle() {
        depthLabel.font = UIFont.systemFont(ofSize: 18)
        depthLabel.textColor = .label
    }
    
    func update(oldModel: EventViewModel?) {
        guard let model = self.model else { return }
        if model.event != nil {
            placeLabel.text = model.event?.name
            
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "UTC")
            formatter.dateFormat = "dd/MM/yy, HH:mm:ss"
            let formattedDate = formatter.string(from: model.event!.date)
            dateLabel.text = formattedDate + " UTC"
            
            latitude = (model.event?.coordinates[1])!
            longitude = (model.event?.coordinates[0])!
            let dms = coordinateToDMS(latitude: latitude, longitude: longitude)
            coordinatesLabel.text = dms.latitude + ", " + dms.longitude
            
            magnitudeLabel.text = String((model.event?.magnitudo)!)
            
            depthLabel.text = String((model.event?.depth)!) + " km"
            
            updateMapView()
        }
    }
    
    private func updateMapView() {
        mapView.clear()
        let location = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 10)
        mapView.animate(to: location)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
    }
    
    private func coordinateToDMS(latitude: Double, longitude: Double) -> (latitude: String, longitude: String) {
        let latDegrees = abs(Int(latitude))
        let latMinutes = abs(Int((latitude * 3600).truncatingRemainder(dividingBy: 3600) / 60))
        let latSeconds = Double(abs((latitude * 3600).truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60)))

        let lonDegrees = abs(Int(longitude))
        let lonMinutes = abs(Int((longitude * 3600).truncatingRemainder(dividingBy: 3600) / 60))
        let lonSeconds = Double(abs((longitude * 3600).truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60) ))
        
        /*return (String(format:"%d° %d' %@", latDegrees, latMinutes, latSeconds, latitude >= 0 ? "N" : "S"),
                String(format:"%d° %d' %@", lonDegrees, lonMinutes, lonSeconds, longitude >= 0 ? "E" : "W"))*/
        
        return (String(format:"%d° %d' %.2f\" %@", latDegrees, latMinutes, latSeconds, latitude >= 0 ? "N" : "S"),
                String(format:"%d° %d' %.2f\" %@", lonDegrees, lonMinutes, lonSeconds, longitude >= 0 ? "E" : "W"))
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainVStackView.translatesAutoresizingMaskIntoConstraints = false
        mainVStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        mainVStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mainVStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mainVStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.heightAnchor.constraint(equalToConstant: 500).isActive = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let mapStyleString: String
        
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            mapStyleString = "light_map_style"
        case .dark:
            mapStyleString = "dark_map_style"
        default:
            mapStyleString = "light_map_style"
        }
        
        do {
          // Set the map style by passing the URL of the local file.
          if let styleURL = Bundle.main.url(forResource: mapStyleString, withExtension: "json") {
            mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
          } else {
            NSLog("Unable to find style.json")
          }
        } catch {
          NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    
}
