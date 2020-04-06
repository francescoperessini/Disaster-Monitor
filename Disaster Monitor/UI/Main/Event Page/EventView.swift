//
//  EventView.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 25/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura
import CoreLocation
import GoogleMaps
import MarqueeLabel

// MARK: - ViewModel
struct EventViewModel: ViewModelWithLocalState {
    var event: Event?
    var color: Color?
    
    init?(state: AppState?, localState: EventControllerLocalState) {
        self.event = state?.events.first(where:{$0.id == localState.id})
        self.color = state?.customColor
    }
}

// MARK: - View
class EventView: UIView, ViewControllerModellableView {
    
    var didTapSafari: ((String) -> ())?
    var didTapShare: ((UIBarButtonItem) -> ())?
    var url: String = ""
    
    var firstRow: UIView = UIView()
    var secondRow: UIView = UIView()
    
    var firstEntireRow: UIView = UIView()
    var secondEntireRow: UIView = UIView()
    var thirdEntireRow: UIView = UIView()
    var thirdSplittedRow: UIView = UIView()
    var fourthSplittedRow: UIView = UIView()
    
    var firstRowFirstCell: UIView = UIView()
    var firstRowSecondCell: UIView = UIView()
    
    var secondRowFirstCell: UIView = UIView()
    var secondRowSecondCell: UIView = UIView()
    
    var mapView = GMSMapView()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var placeLabel = MarqueeLabel.init(frame: .zero, duration: 8.5, fadeLength: 10.0)
    var placeLabelSubtitle = MarqueeLabel.init(frame: .zero, duration: 8.5, fadeLength: 10.0)
    
    var dateLabel = UILabel()
    var coordinatesLabel = UILabel()
    var distanceLabel = UILabel()
    var depthLabel = UILabel()
    
    let size:CGFloat = 55
    let someView = UIView()
    var magnitudoBigLabel = UILabel()
    var magnitudoFeltLabel = UILabel()
    
    let fontSmall = UIFont.systemFont(ofSize: 18)
    
    var dateImage = UIImageView(image: UIImage(systemName: "clock")!.withRenderingMode(.alwaysTemplate))
    var coordinatesImage = UIImageView(image: UIImage(systemName: "mappin")!.withRenderingMode(.alwaysTemplate))
    var magnitudeImage = UIImageView(image: UIImage(systemName: "location")!.withRenderingMode(.alwaysTemplate))
    var depthImage = UIImageView(image: UIImage(systemName: "arrow.down.circle")!.withRenderingMode(.alwaysTemplate))
    
    var coordinates: CLLocation?
    
    func setup() {
        LocationService.sharedInstance.delegate = self
        coordinates = LocationService.sharedInstance.currentLocation
        
        self.addSubview(firstRow)
        self.addSubview(secondRow)
        firstRow.addSubview(firstEntireRow)
        firstRow.addSubview(secondEntireRow)
        firstRow.addSubview(thirdEntireRow)
        firstRow.addSubview(thirdSplittedRow)
        firstRow.addSubview(fourthSplittedRow)
        
        thirdSplittedRow.addSubview(firstRowFirstCell)
        thirdSplittedRow.addSubview(firstRowSecondCell)
        
        fourthSplittedRow.addSubview(secondRowFirstCell)
        fourthSplittedRow.addSubview(secondRowSecondCell)
        
        firstEntireRow.addSubview(placeLabel)
        secondEntireRow.addSubview(placeLabelSubtitle)
        
        firstRowFirstCell.addSubview(coordinatesLabel)
        firstRowFirstCell.addSubview(coordinatesImage)
        
        firstRowSecondCell.addSubview(distanceLabel)
        firstRowSecondCell.addSubview(magnitudeImage)
        
        secondRowFirstCell.addSubview(dateLabel)
        secondRowFirstCell.addSubview(dateImage)
        
        secondRowSecondCell.addSubview(depthLabel)
        secondRowSecondCell.addSubview(depthImage)
        
        secondRow.addSubview(mapView)
        setupMapView()
        
        self.thirdEntireRow.addSubview(someView)
        self.thirdEntireRow.addSubview(magnitudoFeltLabel)
        
        someView.addSubview(magnitudoBigLabel)
    }
    
    private func setupMapView() {
        // compassButton displays only when map is NOT in the north direction
        mapView.settings.compassButton = true
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.tiltGestures = true
    }
    
    //MARK: Styling
    func style() {
        backgroundColor = .systemBackground
        navigationItem?.largeTitleDisplayMode = .never
        navigationItem?.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "safari"), style: .plain, target: self, action: #selector(didTapSafariFunc)), UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShareFunc))]
        
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
        
        placeLabelStyle()
        dateImageStyle()
        dateLabelStyle()
        coordinatesImageStyle()
        coordinatesLabelStyle()
        magnitudeImageStyle()
        magnitudeLabelStyle()
        depthImageStyle()
        depthLabelStyle()
        mapStyle()
        magnitudoLabelStyle()
        magnitudoFeltLabelStyle()
        
        let pulseAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        pulseAnimation.duration = 0.5
        pulseAnimation.fromValue = 0
        pulseAnimation.toValue = 1.0
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        
        self.someView.layer.backgroundColor = UIColor.clear.cgColor
        self.someView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.someView.layer.add(pulseAnimation, forKey: pulseAnimation.keyPath)
    }
    
    private func magnitudoFeltLabelStyle(){
        magnitudoFeltLabel.font = fontSmall
    }
    
    @objc func didTapSafariFunc() {
        didTapSafari?(url)
    }
    
    @objc func didTapShareFunc(sender: UIBarButtonItem){
        didTapShare?(sender)
    }
    
    private func magnitudoLabelStyle(){
        magnitudoBigLabel.font = UIFont.boldSystemFont(ofSize: 20)
        magnitudoBigLabel.layer.cornerRadius = magnitudoBigLabel.frame.width/2
        magnitudoBigLabel.textColor = .white
        magnitudoBigLabel.textAlignment = .center
        magnitudoFeltLabel.numberOfLines = 0
    }
    
    private func mapStyle(){
        mapView.layer.cornerRadius = 10;
    }
    
    private func placeLabelStyle() {
        placeLabel.trailingBuffer = 50
        placeLabel.textAlignment = .center
        placeLabel.font = UIFont.boldSystemFont(ofSize: 25)
        placeLabel.textColor = .label
        
        placeLabelSubtitle.trailingBuffer = 50
        placeLabelSubtitle.textAlignment = .center
        placeLabelSubtitle.font = UIFont.systemFont(ofSize: 16)
        placeLabelSubtitle.textColor = .secondaryLabel
    }
    
    private func dateImageStyle() {
        dateImage.tintColor = .label
    }
    
    private func dateLabelStyle() {
        dateLabel.font = fontSmall
        dateLabel.textColor = .label
    }
    
    private func coordinatesImageStyle() {
        coordinatesImage.tintColor = .label
    }
    
    private func coordinatesLabelStyle() {
        coordinatesLabel.font = fontSmall
        coordinatesLabel.textColor = .label
    }
    
    private func magnitudeImageStyle() {
        magnitudeImage.tintColor = .label
    }
    
    private func magnitudeLabelStyle() {
        distanceLabel.font = fontSmall
        distanceLabel.textColor = .label
    }
    
    private func depthImageStyle() {
        depthImage.tintColor = .label
    }
    
    private func depthLabelStyle() {
        depthLabel.font = fontSmall
        depthLabel.textColor = .label
    }
    
    //MARK: Update
    
    func update(oldModel: EventViewModel?) {
        guard let model = self.model else { return }
        
        if traitCollection.userInterfaceStyle == .light {
            mapStyleByURL(mapStyleString: "light_map_style")
        } else {
            mapStyleByURL(mapStyleString: "dark_map_style")
        }
        
        if model.color != nil {
            navigationBar?.tintColor = model.color!.getColor()
            someView.backgroundColor = model.color!.getColor()
            someView.layer.borderColor = model.color!.getColor().cgColor
            someView.layer.shadowColor = model.color!.getColor().cgColor
        }
        
        if model.event != nil { 
            magnitudoBigLabel.text = String((model.event?.magnitudo)!)
            
            if model.event?.name.contains("of") ?? false {
                placeLabel.text = model.event?.name.components(separatedBy: "of")[1]
                placeLabelSubtitle.text = model.event?.name
            }
            else {
                placeLabel.text = model.event?.name
            }
            
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "UTC")
            formatter.dateFormat = "dd/MM/yy, HH:mm"
            let formattedDate = formatter.string(from: model.event!.date)
            dateLabel.text = formattedDate + " UTC"
            
            latitude = (model.event?.coordinates[1])!
            longitude = (model.event?.coordinates[0])!
            let dms = coordinateToDMS(latitude: latitude, longitude: longitude)
            coordinatesLabel.text = dms.latitude + ", " + dms.longitude
            
            depthLabel.text = String(format:"%.2f km", (model.event?.depth)!)
            
            url = (model.event?.url)!
            
            updateMapView()
            
            magnitudoFeltLabelUpdate(felt: model.event?.felt ?? 0, magnitudo: model.event?.magnitudo ?? 0)
            
            if coordinates != nil {
                let eventCoordinates = CLLocation(latitude: latitude, longitude: longitude)
                let distance = coordinates!.distance(from: eventCoordinates) / 1000
                
                distanceLabel.text = String(format:"%.0f km", distance)
            }
            else {
                distanceLabel.text = "n/a"
            }
        }
    }
    
    private func magnitudoFeltLabelUpdate(felt: Int, magnitudo: Float){
        magnitudoFeltLabel.text = "\(felt)"
        var string: String?
        
        if magnitudo <= 1 {
            string = "Felt only by sensitive people."
        }else if  magnitudo <= 3 {
            string = "Felt slightly by some people."
        }else if  magnitudo <= 5 {
            string = "Noticeable shaking of indoor objects."
        }else {
            string = "Severe damage to most buildings."
        }
        if felt != 0 {
            string?.append(contentsOf: "\nEarthquake reported by \(felt) ")
            if felt == 1 {
                string?.append(contentsOf: "user.")
            }
            else {
                string?.append(contentsOf: "users.")
            }
        }
        magnitudoFeltLabel.text = string
    }
    
    private func updateMapView() {
        mapView.clear()
        let location = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 10)
        mapView.animate(to: location)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        //marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
    }
    
    private func coordinateToDMS(latitude: Double, longitude: Double) -> (latitude: String, longitude: String) {
        let latDegrees = abs(Int(latitude))
        let latMinutes = abs(Int((latitude * 3600).truncatingRemainder(dividingBy: 3600) / 60))
        
        let lonDegrees = abs(Int(longitude))
        let lonMinutes = abs(Int((longitude * 3600).truncatingRemainder(dividingBy: 3600) / 60))
        
        return (String(format:"%d° %d' %@", latDegrees, latMinutes, latitude >= 0 ? "N" : "S"),
                String(format:"%d° %d' %@", lonDegrees, lonMinutes, longitude >= 0 ? "E" : "W"))
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
        
        mapStyleByURL(mapStyleString: mapStyleString)
    }
    
    private func mapStyleByURL(mapStyleString: String) {
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
    
    //MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //MARK: Rows
        
        firstRow.translatesAutoresizingMaskIntoConstraints = false
        firstRow.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        firstRow.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.35).isActive = true
        firstRow.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        firstRow.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        secondRow.translatesAutoresizingMaskIntoConstraints = false
        secondRow.topAnchor.constraint(equalTo: self.firstRow.bottomAnchor).isActive = true
        secondRow.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.65).isActive = true
        secondRow.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        secondRow.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        firstEntireRow.translatesAutoresizingMaskIntoConstraints = false
        firstEntireRow.topAnchor.constraint(equalTo: self.firstRow.topAnchor).isActive = true
        firstEntireRow.heightAnchor.constraint(equalTo: self.firstRow.heightAnchor, multiplier: 0.15).isActive = true
        firstEntireRow.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        firstEntireRow.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        secondEntireRow.translatesAutoresizingMaskIntoConstraints = false
        secondEntireRow.topAnchor.constraint(equalTo: self.firstEntireRow.bottomAnchor).isActive = true
        secondEntireRow.heightAnchor.constraint(equalTo: self.firstRow.heightAnchor, multiplier: 0.1).isActive = true
        secondEntireRow.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        secondEntireRow.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        thirdEntireRow.translatesAutoresizingMaskIntoConstraints = false
        thirdEntireRow.topAnchor.constraint(equalTo: self.firstEntireRow.bottomAnchor).isActive = true
        thirdEntireRow.heightAnchor.constraint(equalTo: self.firstRow.heightAnchor, multiplier: 0.35).isActive = true
        thirdEntireRow.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        thirdEntireRow.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        thirdSplittedRow.translatesAutoresizingMaskIntoConstraints = false
        thirdSplittedRow.topAnchor.constraint(equalTo: self.thirdEntireRow.bottomAnchor).isActive = true
        thirdSplittedRow.heightAnchor.constraint(equalTo: self.firstRow.heightAnchor, multiplier: 0.2).isActive = true
        thirdSplittedRow.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        thirdSplittedRow.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        fourthSplittedRow.translatesAutoresizingMaskIntoConstraints = false
        fourthSplittedRow.topAnchor.constraint(equalTo: self.thirdSplittedRow.bottomAnchor).isActive = true
        fourthSplittedRow.heightAnchor.constraint(equalTo: self.firstRow.heightAnchor, multiplier: 0.2).isActive = true
        fourthSplittedRow.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        fourthSplittedRow.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        //MARK: Cells
        
        firstRowFirstCell.translatesAutoresizingMaskIntoConstraints = false
        firstRowFirstCell.topAnchor.constraint(equalTo: self.thirdSplittedRow.topAnchor).isActive = true
        firstRowFirstCell.heightAnchor.constraint(equalTo: self.firstRow.heightAnchor).isActive = true
        firstRowFirstCell.widthAnchor.constraint(equalTo: self.thirdSplittedRow.widthAnchor, multiplier: 0.65).isActive = true
        firstRowFirstCell.leadingAnchor.constraint(equalTo: self.thirdSplittedRow.leadingAnchor).isActive = true
        
        firstRowSecondCell.translatesAutoresizingMaskIntoConstraints = false
        firstRowSecondCell.topAnchor.constraint(equalTo: self.thirdSplittedRow.topAnchor).isActive = true
        firstRowSecondCell.heightAnchor.constraint(equalTo: self.firstRow.heightAnchor).isActive = true
        firstRowSecondCell.widthAnchor.constraint(equalTo: self.thirdSplittedRow.widthAnchor, multiplier: 0.35).isActive = true
        firstRowSecondCell.leadingAnchor.constraint(equalTo: self.firstRowFirstCell.trailingAnchor).isActive = true
        
        secondRowFirstCell.translatesAutoresizingMaskIntoConstraints = false
        secondRowFirstCell.topAnchor.constraint(equalTo: self.fourthSplittedRow.topAnchor).isActive = true
        secondRowFirstCell.heightAnchor.constraint(equalTo: self.secondRow.heightAnchor).isActive = true
        secondRowFirstCell.widthAnchor.constraint(equalTo: self.fourthSplittedRow.widthAnchor, multiplier: 0.65).isActive = true
        secondRowFirstCell.leadingAnchor.constraint(equalTo: self.fourthSplittedRow.leadingAnchor).isActive = true
        
        secondRowSecondCell.translatesAutoresizingMaskIntoConstraints = false
        secondRowSecondCell.topAnchor.constraint(equalTo: self.fourthSplittedRow.topAnchor).isActive = true
        secondRowSecondCell.heightAnchor.constraint(equalTo: self.secondRow.heightAnchor).isActive = true
        secondRowSecondCell.widthAnchor.constraint(equalTo: self.fourthSplittedRow.widthAnchor, multiplier: 0.35).isActive = true
        secondRowSecondCell.leadingAnchor.constraint(equalTo: self.secondRowFirstCell.trailingAnchor).isActive = true
        
        //MARK: Content
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: secondRow.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: secondRow.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        mapView.leadingAnchor.constraint(equalTo: secondRow.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        mapView.trailingAnchor.constraint(equalTo: secondRow.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        placeLabel.bottomAnchor.constraint(equalTo: firstEntireRow.bottomAnchor).isActive = true
        placeLabel.leadingAnchor.constraint(equalTo: self.firstRow.leadingAnchor, constant: 20).isActive = true
        placeLabel.trailingAnchor.constraint(equalTo: self.firstRow.trailingAnchor, constant: -20).isActive = true
        placeLabel.centerXAnchor.constraint(equalTo: self.firstRow.centerXAnchor).isActive = true
        //placeLabel.centerYAnchor.constraint(equalTo: self.firstEntireRow.centerYAnchor).isActive = true
        
        placeLabelSubtitle.translatesAutoresizingMaskIntoConstraints = false
        placeLabelSubtitle.bottomAnchor.constraint(equalTo: secondEntireRow.bottomAnchor).isActive = true
        //placeLabelSubtitle.leadingAnchor.constraint(equalTo: self.firstRow.leadingAnchor, constant: 25).isActive = true
        //placeLabelSubtitle.trailingAnchor.constraint(equalTo: self.firstRow.trailingAnchor, constant: -25).isActive = true
        placeLabelSubtitle.centerXAnchor.constraint(equalTo: self.firstRow.centerXAnchor).isActive = true
        
        coordinatesLabel.translatesAutoresizingMaskIntoConstraints = false
        coordinatesLabel.topAnchor.constraint(equalTo: thirdSplittedRow.topAnchor).isActive = true
        //coordinatesLabel.centerXAnchor.constraint(equalTo: self.firstRowFirstCell.centerXAnchor).isActive = true
        coordinatesLabel.centerYAnchor.constraint(equalTo: self.thirdSplittedRow.centerYAnchor).isActive = true
        coordinatesLabel.leadingAnchor.constraint(equalTo: coordinatesImage.trailingAnchor, constant: 20).isActive = true
        
        coordinatesImage.translatesAutoresizingMaskIntoConstraints = false
        coordinatesImage.leadingAnchor.constraint(equalTo: self.firstRowFirstCell.leadingAnchor, constant: 20).isActive = true
        coordinatesImage.centerYAnchor.constraint(equalTo: self.thirdSplittedRow.centerYAnchor).isActive = true
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.topAnchor.constraint(equalTo: thirdSplittedRow.topAnchor).isActive = true
        //distanceLabel.centerXAnchor.constraint(equalTo: self.firstRowSecondCell.centerXAnchor).isActive = true
        distanceLabel.centerYAnchor.constraint(equalTo: self.thirdSplittedRow.centerYAnchor).isActive = true
        distanceLabel.leadingAnchor.constraint(equalTo: magnitudeImage.trailingAnchor, constant: 20).isActive = true
        
        magnitudeImage.translatesAutoresizingMaskIntoConstraints = false
        magnitudeImage.leadingAnchor.constraint(equalTo: self.firstRowSecondCell.leadingAnchor, constant: 0).isActive = true
        magnitudeImage.centerYAnchor.constraint(equalTo: self.thirdSplittedRow.centerYAnchor).isActive = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: fourthSplittedRow.topAnchor).isActive = true
        //dateLabel.centerXAnchor.constraint(equalTo: self.secondRowFirstCell.centerXAnchor).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: self.fourthSplittedRow.centerYAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: dateImage.trailingAnchor, constant: 20).isActive = true
        
        dateImage.translatesAutoresizingMaskIntoConstraints = false
        dateImage.leadingAnchor.constraint(equalTo: self.secondRowFirstCell.leadingAnchor, constant: 20).isActive = true
        dateImage.centerYAnchor.constraint(equalTo: self.fourthSplittedRow.centerYAnchor).isActive = true
        
        depthLabel.translatesAutoresizingMaskIntoConstraints = false
        depthLabel.topAnchor.constraint(equalTo: fourthSplittedRow.topAnchor).isActive = true
        //depthLabel.centerXAnchor.constraint(equalTo: self.secondRowSecondCell.centerXAnchor).isActive = true
        depthLabel.centerYAnchor.constraint(equalTo: self.fourthSplittedRow.centerYAnchor).isActive = true
        depthLabel.leadingAnchor.constraint(equalTo: depthImage.trailingAnchor, constant: 20).isActive = true
        
        
        depthImage.translatesAutoresizingMaskIntoConstraints = false
        depthImage.leadingAnchor.constraint(equalTo: self.secondRowSecondCell.leadingAnchor, constant: 0).isActive = true
        depthImage.centerYAnchor.constraint(equalTo: self.fourthSplittedRow.centerYAnchor).isActive = true
        
        
        someView.translatesAutoresizingMaskIntoConstraints = false
        someView.layer.cornerRadius = size/2
        someView.layer.borderWidth = 1
        
        someView.topAnchor.constraint(equalTo: thirdEntireRow.topAnchor, constant: 20).isActive = true
        someView.leadingAnchor.constraint(equalTo: thirdEntireRow.leadingAnchor, constant: 20).isActive = true
        someView.heightAnchor.constraint(equalToConstant: size).isActive = true
        someView.widthAnchor.constraint(equalToConstant: size).isActive = true
        
        magnitudoBigLabel.translatesAutoresizingMaskIntoConstraints = false
        someView.addSubview(magnitudoBigLabel)
        
        magnitudoBigLabel.centerXAnchor.constraint(equalTo: someView.centerXAnchor).isActive = true
        magnitudoBigLabel.centerYAnchor.constraint(equalTo: someView.centerYAnchor).isActive = true
        
        magnitudoFeltLabel.translatesAutoresizingMaskIntoConstraints = false
        magnitudoFeltLabel.leadingAnchor.constraint(equalTo: someView.trailingAnchor, constant: 20).isActive = true
        magnitudoFeltLabel.centerYAnchor.constraint(equalTo: someView.centerYAnchor).isActive = true
        magnitudoFeltLabel.widthAnchor.constraint(equalTo: thirdEntireRow.widthAnchor, multiplier: 0.7).isActive = true
        magnitudoFeltLabel.heightAnchor.constraint(equalTo: thirdEntireRow.heightAnchor).isActive = true
    }
}

extension UITextView {
    func centerContentVertically() {
        let fitSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fitSize)
        let heightOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(0, heightOffset)
        contentOffset.y = -positiveTopOffset
    }
}

extension EventView: LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation) {
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        coordinates = CLLocation(latitude: lat, longitude: lon)
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
    }
    
}
