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
        
    var mainVStackViewContainer = UIView()
    var mainVStackView = UIStackView()

    var infoHStackView = UIStackView()
    var placeLabel = UILabel()
    var firstColumnVStackView = UIStackView()
    var dateHStackView = UIStackView()
    var dateImage = UIImageView(image: UIImage(systemName: "clock")!.withRenderingMode(.alwaysTemplate))
    var dateLabel = UILabel()
    var coordinatesHStackView = UIStackView()
    var coordinatesImage = UIImageView(image: UIImage(systemName: "mappin")!.withRenderingMode(.alwaysTemplate))
    var coordinatesLabel = UILabel()
    var secondColumnVStackView = UIStackView()
    var magnitudeHStackView = UIStackView()
    var magnitudeImage = UIImageView(image: UIImage(systemName: "waveform.path.ecg")!.withRenderingMode(.alwaysTemplate))
    var magnitudeLabel = UILabel()
    var depthHStackView = UIStackView()
    var depthImage = UIImageView(image: UIImage(systemName: "arrow.down.circle")!.withRenderingMode(.alwaysTemplate))
    var depthLabel = UILabel()
    
    var mapContainer = UIView()
    var mapView = GMSMapView()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
        
    func setup() {
        addSubview(mainVStackViewContainer)
        mainVStackViewContainer.addSubview(mainVStackView)
        setupMainVStackView()
        
        addSubview(mapContainer)
        mapContainer.addSubview(mapView)
        setupMapView()
    }
    
    private func setupMainVStackView() {
        mainVStackView.axis = .vertical
        mainVStackView.distribution = .fillProportionally
        mainVStackView.alignment = .fill
        mainVStackView.spacing = 0.0
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeLabel)
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        placeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        placeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        placeLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        view.backgroundColor = .systemGray6
        
        setupInfoHStackView()
        
        mainVStackView.addArrangedSubview(view)
        mainVStackView.addArrangedSubview(infoHStackView)
    }
    
    private func setupInfoHStackView() {
        infoHStackView.translatesAutoresizingMaskIntoConstraints = false
        infoHStackView.axis = .horizontal
        infoHStackView.distribution = .fillProportionally
        infoHStackView.alignment = .fill
        // se metti spacing 1.0 il constraint si rompe
        infoHStackView.spacing = 0.0
        
        setupFirstColumnVStackView()
        setupSecondColumnVStackView()
        
        infoHStackView.addArrangedSubview(firstColumnVStackView)
        infoHStackView.addArrangedSubview(secondColumnVStackView)
    }
    
    private func setupFirstColumnVStackView() {
        firstColumnVStackView.translatesAutoresizingMaskIntoConstraints = false
        firstColumnVStackView.axis = .vertical
        firstColumnVStackView.distribution = .fillEqually
        firstColumnVStackView.alignment = .fill
        firstColumnVStackView.spacing = 0.0
        
        let dateView = UIView()
        dateView.translatesAutoresizingMaskIntoConstraints = false
        dateView.addSubview(dateHStackView)
        dateHStackView.leadingAnchor.constraint(equalTo: dateView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        dateHStackView.trailingAnchor.constraint(equalTo: dateView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        dateHStackView.centerYAnchor.constraint(equalTo: dateView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        dateView.backgroundColor = .systemGray6
        
        let coordinatesView = UIView()
        coordinatesView.translatesAutoresizingMaskIntoConstraints = false
        coordinatesView.addSubview(coordinatesHStackView)
        coordinatesHStackView.leadingAnchor.constraint(equalTo: coordinatesView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        coordinatesHStackView.trailingAnchor.constraint(equalTo: coordinatesView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        coordinatesHStackView.centerYAnchor.constraint(equalTo: coordinatesView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        coordinatesView.backgroundColor = .systemGray6
        
        setupDateHStackView()
        setupCoordinatesHStackView()
        
        firstColumnVStackView.addArrangedSubview(dateView)
        firstColumnVStackView.addArrangedSubview(coordinatesView)
    }
    
    private func setupDateHStackView() {
        dateHStackView.translatesAutoresizingMaskIntoConstraints = false
        dateHStackView.axis = .horizontal
        dateHStackView.distribution = .equalCentering
        dateHStackView.alignment = .center
        dateHStackView.spacing = 0.0
        
        dateHStackView.addArrangedSubview(dateImage)
        dateHStackView.addArrangedSubview(dateLabel)
    }
    
    private func setupCoordinatesHStackView() {
        coordinatesHStackView.translatesAutoresizingMaskIntoConstraints = false
        coordinatesHStackView.axis = .horizontal
        coordinatesHStackView.distribution = .equalCentering
        coordinatesHStackView.alignment = .center
        coordinatesHStackView.spacing = 0.0
        
        coordinatesHStackView.addArrangedSubview(coordinatesImage)
        coordinatesHStackView.addArrangedSubview(coordinatesLabel)
    }
    
    private func setupSecondColumnVStackView() {
        secondColumnVStackView.translatesAutoresizingMaskIntoConstraints = false
        secondColumnVStackView.axis = .vertical
        secondColumnVStackView.distribution = .fillEqually
        secondColumnVStackView.alignment = .fill
        secondColumnVStackView.spacing = 0.0
        
        let magnitudeView = UIView()
        magnitudeView.translatesAutoresizingMaskIntoConstraints = false
        magnitudeView.addSubview(magnitudeHStackView)
        magnitudeHStackView.leadingAnchor.constraint(equalTo: magnitudeView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        magnitudeHStackView.trailingAnchor.constraint(equalTo: magnitudeView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        magnitudeHStackView.centerYAnchor.constraint(equalTo: magnitudeView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        magnitudeView.backgroundColor = .systemGray6
        
        let depthView = UIView()
        depthView.translatesAutoresizingMaskIntoConstraints = false
        depthView.addSubview(depthHStackView)
        depthHStackView.leadingAnchor.constraint(equalTo: depthView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        depthHStackView.trailingAnchor.constraint(equalTo: depthView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        depthHStackView.centerYAnchor.constraint(equalTo: depthView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        depthView.backgroundColor = .systemGray6
        
        setupMagnitudeHStackView()
        setupDepthHStackView()
        
        secondColumnVStackView.addArrangedSubview(magnitudeView)
        secondColumnVStackView.addArrangedSubview(depthView)
    }
    
    private func setupMagnitudeHStackView() {
        magnitudeHStackView.translatesAutoresizingMaskIntoConstraints = false
        magnitudeHStackView.axis = .horizontal
        magnitudeHStackView.distribution = .equalCentering
        magnitudeHStackView.alignment = .center
        magnitudeHStackView.spacing = 0.0
    
        magnitudeHStackView.addArrangedSubview(magnitudeImage)
        magnitudeHStackView.addArrangedSubview(magnitudeLabel)
    }
    
    private func setupDepthHStackView() {
        depthHStackView.translatesAutoresizingMaskIntoConstraints = false
        depthHStackView.axis = .horizontal
        depthHStackView.distribution = .equalCentering
        depthHStackView.alignment = .center
        depthHStackView.spacing = 0.0
        
        depthHStackView.addArrangedSubview(depthImage)
        depthHStackView.addArrangedSubview(depthLabel)
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
        placeLabel.font = UIFont.boldSystemFont(ofSize: 20)
        placeLabel.textColor = .label
    }
    
    private func dateImageStyle() {
        dateImage.tintColor = .label
    }
    
    private func dateLabelStyle() {
        dateLabel.font = UIFont.systemFont(ofSize: 15)
        dateLabel.textColor = .label
    }
    
    private func coordinatesImageStyle() {
        coordinatesImage.tintColor = .label
    }
    
    private func coordinatesLabelStyle() {
        coordinatesLabel.font = UIFont.systemFont(ofSize: 15)
        coordinatesLabel.textColor = .label
    }
    
    private func magnitudeImageStyle() {
        magnitudeImage.tintColor = .label
    }
    
    private func magnitudeLabelStyle() {
        magnitudeLabel.font = UIFont.systemFont(ofSize: 15)
        magnitudeLabel.textColor = .label
    }
    
    private func depthImageStyle() {
        depthImage.tintColor = .label
    }
    
    private func depthLabelStyle() {
        depthLabel.font = UIFont.systemFont(ofSize: 15)
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
        //let latSeconds = Double(abs((latitude * 3600).truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60)))

        let lonDegrees = abs(Int(longitude))
        let lonMinutes = abs(Int((longitude * 3600).truncatingRemainder(dividingBy: 3600) / 60))
        //let lonSeconds = Double(abs((longitude * 3600).truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60) ))
    
        return (String(format:"%d° %d' %@", latDegrees, latMinutes, latitude >= 0 ? "N" : "S"),
                String(format:"%d° %d' %@", lonDegrees, lonMinutes, longitude >= 0 ? "E" : "W"))
        
        /*
        return (String(format:"%d° %d' %.2f\" %@", latDegrees, latMinutes, latSeconds, latitude >= 0 ? "N" : "S"),
                String(format:"%d° %d' %.2f\" %@", lonDegrees, lonMinutes, lonSeconds, longitude >= 0 ? "E" : "W"))
        */
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainVStackViewContainer.translatesAutoresizingMaskIntoConstraints = false
        mainVStackViewContainer.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        mainVStackViewContainer.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        mainVStackViewContainer.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        mainVStackViewContainer.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.4).isActive = true
        
        mainVStackView.translatesAutoresizingMaskIntoConstraints = false
        mainVStackView.topAnchor.constraint(equalTo: mainVStackViewContainer.safeAreaLayoutGuide.topAnchor).isActive = true
        mainVStackView.bottomAnchor.constraint(equalTo: mainVStackViewContainer.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mainVStackView.leadingAnchor.constraint(equalTo: mainVStackViewContainer.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mainVStackView.trailingAnchor.constraint(equalTo: mainVStackViewContainer.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        mapContainer.translatesAutoresizingMaskIntoConstraints = false
        mapContainer.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapContainer.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mapContainer.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        mapContainer.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.6).isActive = true
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: mapContainer.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: mapContainer.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: mapContainer.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: mapContainer.safeAreaLayoutGuide.trailingAnchor).isActive = true
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
