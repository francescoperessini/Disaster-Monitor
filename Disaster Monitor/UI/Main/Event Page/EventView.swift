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
        
    var firstRow: UIView = UIView()
    var secondRow: UIView = UIView()
    
    var firstEntireRow: UIView = UIView()
    var secondEntireRow: UIView = UIView()
    var thirdSplittedRow: UIView = UIView()
    var fourthSplittedRow: UIView = UIView()
    
    var firstRowFirstCell: UIView = UIView()
    var firstRowSecondCell: UIView = UIView()
    
    var secondRowFirstCell: UIView = UIView()
    var secondRowSecondCell: UIView = UIView()
    
    var mapView = GMSMapView()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var placeLabel = UILabel()
    var dateLabel = UILabel()
    var coordinatesLabel = UILabel()
    var magnitudeLabel = UILabel()
    var depthLabel = UILabel()
    
    let size:CGFloat = 48
    let someView = UIView()
    var magnitudoBigLabel = UILabel()
    
    let fontSmall = UIFont.systemFont(ofSize: 18)
    
    var dateImage = UIImageView(image: UIImage(systemName: "clock")!.withRenderingMode(.alwaysTemplate))
    var coordinatesImage = UIImageView(image: UIImage(systemName: "mappin")!.withRenderingMode(.alwaysTemplate))
    var magnitudeImage = UIImageView(image: UIImage(systemName: "waveform.path.ecg")!.withRenderingMode(.alwaysTemplate))
    var depthImage = UIImageView(image: UIImage(systemName: "arrow.down.circle")!.withRenderingMode(.alwaysTemplate))

    
    func setup() {
        self.addSubview(firstRow)
        self.addSubview(secondRow)
        firstRow.addSubview(firstEntireRow)
        firstRow.addSubview(secondEntireRow)
        firstRow.addSubview(thirdSplittedRow)
        firstRow.addSubview(fourthSplittedRow)
        
        
        thirdSplittedRow.addSubview(firstRowFirstCell)
        thirdSplittedRow.addSubview(firstRowSecondCell)
        
        fourthSplittedRow.addSubview(secondRowFirstCell)
        fourthSplittedRow.addSubview(secondRowSecondCell)
        
        firstRow.addSubview(placeLabel)
        
        firstRowFirstCell.addSubview(coordinatesLabel)
        firstRowFirstCell.addSubview(coordinatesImage)
        
        firstRowSecondCell.addSubview(magnitudeLabel)
        firstRowSecondCell.addSubview(magnitudeImage)
        
        secondRowFirstCell.addSubview(dateLabel)
        secondRowFirstCell.addSubview(dateImage)
        
        secondRowSecondCell.addSubview(depthLabel)
        secondRowSecondCell.addSubview(depthImage)
        
        secondRow.addSubview(mapView)
        setupMapView()
        
        self.secondEntireRow.addSubview(someView)
        
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
        backgroundColor = .systemGray6
        navigationItem?.largeTitleDisplayMode = .never
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.label] // cambia aspetto del titolo
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label] // cambia aspetto del titolo (con prefersLargeTitles = true)
            navigationBar?.tintColor = .systemBlue // tintColor changes the color of the UIBarButtonItem
            navBarAppearance.backgroundColor = .systemGray6 // cambia il colore dello sfondo della navigation bar
            navigationBar?.standardAppearance = navBarAppearance
            navigationBar?.scrollEdgeAppearance = navBarAppearance
        } else {
            navigationBar?.tintColor = .systemBlue
            navigationBar?.barTintColor = .systemGray6
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
        magnitudoBigLabelStyle()
    }
    
    private func magnitudoBigLabelStyle(){
        magnitudoBigLabel.font = UIFont.boldSystemFont(ofSize: 20)
        magnitudoBigLabel.layer.cornerRadius = magnitudoBigLabel.frame.width/2
        
        magnitudoBigLabel.textColor = UIColor.white
        magnitudoBigLabel.textAlignment = .center
        //magnitudoBigLabel.font = UIFont.systemFont(ofSize: 14.0)

        
    }
    
    private func mapStyle(){
        mapView.layer.cornerRadius = 10;
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
        magnitudeLabel.font = fontSmall
        magnitudeLabel.textColor = .label
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
        if model.event != nil {
            magnitudoBigLabel.text = String((model.event?.magnitudo)!)
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

        let lonDegrees = abs(Int(longitude))
        let lonMinutes = abs(Int((longitude * 3600).truncatingRemainder(dividingBy: 3600) / 60))
    
        return (String(format:"%d° %d' %@", latDegrees, latMinutes, latitude >= 0 ? "N" : "S"),
                String(format:"%d° %d' %@", lonDegrees, lonMinutes, longitude >= 0 ? "E" : "W"))
    }
    
    //MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //MARK: Rows
        
        firstRow.translatesAutoresizingMaskIntoConstraints = false
        firstRow.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        firstRow.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.3).isActive = true
        firstRow.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        firstRow.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        secondRow.translatesAutoresizingMaskIntoConstraints = false
        secondRow.topAnchor.constraint(equalTo: self.firstRow.bottomAnchor).isActive = true
        secondRow.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.7).isActive = true
        secondRow.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        secondRow.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        firstEntireRow.translatesAutoresizingMaskIntoConstraints = false
        firstEntireRow.topAnchor.constraint(equalTo: self.firstRow.topAnchor).isActive = true
        firstEntireRow.heightAnchor.constraint(equalTo: self.firstRow.heightAnchor, multiplier: 0.2).isActive = true
        firstEntireRow.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        firstEntireRow.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        secondEntireRow.translatesAutoresizingMaskIntoConstraints = false
        secondEntireRow.topAnchor.constraint(equalTo: self.firstEntireRow.bottomAnchor).isActive = true
        secondEntireRow.heightAnchor.constraint(equalTo: self.firstRow.heightAnchor, multiplier: 0.3).isActive = true
        secondEntireRow.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        secondEntireRow.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        thirdSplittedRow.translatesAutoresizingMaskIntoConstraints = false
        thirdSplittedRow.topAnchor.constraint(equalTo: self.secondEntireRow.bottomAnchor).isActive = true
        thirdSplittedRow.heightAnchor.constraint(equalTo: self.firstRow.heightAnchor, multiplier: 0.25).isActive = true
        thirdSplittedRow.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        thirdSplittedRow.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        fourthSplittedRow.translatesAutoresizingMaskIntoConstraints = false
        fourthSplittedRow.topAnchor.constraint(equalTo: self.thirdSplittedRow.bottomAnchor).isActive = true
        fourthSplittedRow.heightAnchor.constraint(equalTo: self.firstRow.heightAnchor, multiplier: 0.25).isActive = true
        fourthSplittedRow.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        fourthSplittedRow.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        //MARK: Cells
        
        firstRowFirstCell.translatesAutoresizingMaskIntoConstraints = false
        firstRowFirstCell.topAnchor.constraint(equalTo: self.thirdSplittedRow.topAnchor).isActive = true
        firstRowFirstCell.heightAnchor.constraint(equalTo: self.firstRow.heightAnchor).isActive = true
        firstRowFirstCell.widthAnchor.constraint(equalTo: self.thirdSplittedRow.widthAnchor, multiplier: 0.7).isActive = true
        firstRowFirstCell.leadingAnchor.constraint(equalTo: self.thirdSplittedRow.leadingAnchor).isActive = true
        
        firstRowSecondCell.translatesAutoresizingMaskIntoConstraints = false
        firstRowSecondCell.topAnchor.constraint(equalTo: self.thirdSplittedRow.topAnchor).isActive = true
        firstRowSecondCell.heightAnchor.constraint(equalTo: self.firstRow.heightAnchor).isActive = true
        firstRowSecondCell.widthAnchor.constraint(equalTo: self.thirdSplittedRow.widthAnchor, multiplier: 0.3).isActive = true
        firstRowSecondCell.leadingAnchor.constraint(equalTo: self.firstRowFirstCell.trailingAnchor).isActive = true
        
        secondRowFirstCell.translatesAutoresizingMaskIntoConstraints = false
        secondRowFirstCell.topAnchor.constraint(equalTo: self.fourthSplittedRow.topAnchor).isActive = true
        secondRowFirstCell.heightAnchor.constraint(equalTo: self.secondRow.heightAnchor).isActive = true
        secondRowFirstCell.widthAnchor.constraint(equalTo: self.fourthSplittedRow.widthAnchor, multiplier: 0.7).isActive = true
        secondRowFirstCell.leadingAnchor.constraint(equalTo: self.fourthSplittedRow.leadingAnchor).isActive = true
        
        secondRowSecondCell.translatesAutoresizingMaskIntoConstraints = false
        secondRowSecondCell.topAnchor.constraint(equalTo: self.fourthSplittedRow.topAnchor).isActive = true
        secondRowSecondCell.heightAnchor.constraint(equalTo: self.secondRow.heightAnchor).isActive = true
        secondRowSecondCell.widthAnchor.constraint(equalTo: self.fourthSplittedRow.widthAnchor, multiplier: 0.3).isActive = true
        secondRowSecondCell.leadingAnchor.constraint(equalTo: self.secondRowFirstCell.trailingAnchor).isActive = true
        
        //MARK: Content
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: secondRow.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: secondRow.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        mapView.leadingAnchor.constraint(equalTo: secondRow.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        mapView.trailingAnchor.constraint(equalTo: secondRow.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        placeLabel.topAnchor.constraint(equalTo: firstRow.topAnchor).isActive = true
        placeLabel.centerXAnchor.constraint(equalTo: self.firstRow.centerXAnchor).isActive = true
        placeLabel.centerYAnchor.constraint(equalTo: self.firstEntireRow.centerYAnchor).isActive = true
        
        coordinatesLabel.translatesAutoresizingMaskIntoConstraints = false
        coordinatesLabel.topAnchor.constraint(equalTo: thirdSplittedRow.topAnchor).isActive = true
        coordinatesLabel.centerXAnchor.constraint(equalTo: self.firstRowFirstCell.centerXAnchor).isActive = true
        coordinatesLabel.centerYAnchor.constraint(equalTo: self.thirdSplittedRow.centerYAnchor).isActive = true
        
        coordinatesImage.translatesAutoresizingMaskIntoConstraints = false
        coordinatesImage.leadingAnchor.constraint(equalTo: self.firstRowFirstCell.leadingAnchor, constant: 20).isActive = true
        coordinatesImage.centerYAnchor.constraint(equalTo: self.thirdSplittedRow.centerYAnchor).isActive = true
        
        magnitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        magnitudeLabel.topAnchor.constraint(equalTo: thirdSplittedRow.topAnchor).isActive = true
        magnitudeLabel.centerXAnchor.constraint(equalTo: self.firstRowSecondCell.centerXAnchor).isActive = true
        magnitudeLabel.centerYAnchor.constraint(equalTo: self.thirdSplittedRow.centerYAnchor).isActive = true
        
        magnitudeImage.translatesAutoresizingMaskIntoConstraints = false
        magnitudeImage.leadingAnchor.constraint(equalTo: self.firstRowSecondCell.leadingAnchor, constant: 0).isActive = true
        magnitudeImage.centerYAnchor.constraint(equalTo: self.thirdSplittedRow.centerYAnchor).isActive = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: fourthSplittedRow.topAnchor).isActive = true
        dateLabel.centerXAnchor.constraint(equalTo: self.secondRowFirstCell.centerXAnchor).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: self.fourthSplittedRow.centerYAnchor).isActive = true
        
        dateImage.translatesAutoresizingMaskIntoConstraints = false
        dateImage.leadingAnchor.constraint(equalTo: self.secondRowFirstCell.leadingAnchor, constant: 20).isActive = true
        dateImage.centerYAnchor.constraint(equalTo: self.fourthSplittedRow.centerYAnchor).isActive = true
        
        depthLabel.translatesAutoresizingMaskIntoConstraints = false
        depthLabel.topAnchor.constraint(equalTo: fourthSplittedRow.topAnchor).isActive = true
        depthLabel.centerXAnchor.constraint(equalTo: self.secondRowSecondCell.centerXAnchor).isActive = true
        depthLabel.centerYAnchor.constraint(equalTo: self.fourthSplittedRow.centerYAnchor).isActive = true
        
        depthImage.translatesAutoresizingMaskIntoConstraints = false
        depthImage.leadingAnchor.constraint(equalTo: self.secondRowSecondCell.leadingAnchor, constant: 0).isActive = true
        depthImage.centerYAnchor.constraint(equalTo: self.fourthSplittedRow.centerYAnchor).isActive = true
        
        
        someView.translatesAutoresizingMaskIntoConstraints = false
        someView.layer.cornerRadius = size/2
        someView.backgroundColor = .systemBlue
        someView.layer.borderColor = UIColor.systemBlue.cgColor
        someView.layer.borderWidth = 1
        
        someView.topAnchor.constraint(equalTo: secondEntireRow.topAnchor).isActive = true
        someView.leadingAnchor.constraint(equalTo: secondEntireRow.leadingAnchor, constant: 20).isActive = true
        someView.heightAnchor.constraint(equalToConstant: size).isActive = true
        someView.widthAnchor.constraint(equalToConstant: size).isActive = true
        
        magnitudoBigLabel.translatesAutoresizingMaskIntoConstraints = false
        someView.addSubview(magnitudoBigLabel)
        
        magnitudoBigLabel.centerXAnchor.constraint(equalTo: someView.centerXAnchor).isActive = true
        magnitudoBigLabel.centerYAnchor.constraint(equalTo: someView.centerYAnchor).isActive = true
    }
}
