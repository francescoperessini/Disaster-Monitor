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
    var secondSplittedRow: UIView = UIView()
    var thirdSplittedRow: UIView = UIView()
    
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
    
    
    var dateImage = UIImageView(image: UIImage(systemName: "clock")!.withRenderingMode(.alwaysTemplate))
    var coordinatesImage = UIImageView(image: UIImage(systemName: "mappin")!.withRenderingMode(.alwaysTemplate))
    var magnitudeImage = UIImageView(image: UIImage(systemName: "waveform.path.ecg")!.withRenderingMode(.alwaysTemplate))
    var depthImage = UIImageView(image: UIImage(systemName: "arrow.down.circle")!.withRenderingMode(.alwaysTemplate))

    
    func setup() {
        self.addSubview(firstRow)
        self.addSubview(secondRow)
        firstRow.addSubview(firstEntireRow)
        firstRow.addSubview(secondSplittedRow)
        firstRow.addSubview(thirdSplittedRow)
        
        secondSplittedRow.addSubview(firstRowFirstCell)
        secondSplittedRow.addSubview(firstRowSecondCell)
        
        thirdSplittedRow.addSubview(secondRowFirstCell)
        thirdSplittedRow.addSubview(secondRowSecondCell)
        
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
    
    //MARK: Update

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
        
        secondSplittedRow.translatesAutoresizingMaskIntoConstraints = false
        secondSplittedRow.topAnchor.constraint(equalTo: self.firstEntireRow.bottomAnchor).isActive = true
        secondSplittedRow.heightAnchor.constraint(equalTo: self.firstRow.heightAnchor, multiplier: 0.4).isActive = true
        secondSplittedRow.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        secondSplittedRow.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        thirdSplittedRow.translatesAutoresizingMaskIntoConstraints = false
        thirdSplittedRow.topAnchor.constraint(equalTo: self.secondSplittedRow.bottomAnchor).isActive = true
        thirdSplittedRow.heightAnchor.constraint(equalTo: self.firstRow.heightAnchor, multiplier: 0.4).isActive = true
        thirdSplittedRow.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        thirdSplittedRow.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        //MARK: Cells
        
        firstRowFirstCell.translatesAutoresizingMaskIntoConstraints = false
        firstRowFirstCell.topAnchor.constraint(equalTo: self.secondSplittedRow.topAnchor).isActive = true
        firstRowFirstCell.heightAnchor.constraint(equalTo: self.firstRow.heightAnchor).isActive = true
        firstRowFirstCell.widthAnchor.constraint(equalTo: self.secondSplittedRow.widthAnchor, multiplier: 0.7).isActive = true
        firstRowFirstCell.leadingAnchor.constraint(equalTo: self.secondSplittedRow.leadingAnchor).isActive = true
        
        firstRowSecondCell.translatesAutoresizingMaskIntoConstraints = false
        firstRowSecondCell.topAnchor.constraint(equalTo: self.secondSplittedRow.topAnchor).isActive = true
        firstRowSecondCell.heightAnchor.constraint(equalTo: self.firstRow.heightAnchor).isActive = true
        firstRowSecondCell.widthAnchor.constraint(equalTo: self.secondSplittedRow.widthAnchor, multiplier: 0.3).isActive = true
        firstRowSecondCell.leadingAnchor.constraint(equalTo: self.firstRowFirstCell.trailingAnchor).isActive = true
        
        secondRowFirstCell.translatesAutoresizingMaskIntoConstraints = false
        secondRowFirstCell.topAnchor.constraint(equalTo: self.thirdSplittedRow.topAnchor).isActive = true
        secondRowFirstCell.heightAnchor.constraint(equalTo: self.secondRow.heightAnchor).isActive = true
        secondRowFirstCell.widthAnchor.constraint(equalTo: self.thirdSplittedRow.widthAnchor, multiplier: 0.7).isActive = true
        secondRowFirstCell.leadingAnchor.constraint(equalTo: self.thirdSplittedRow.leadingAnchor).isActive = true
        
        secondRowSecondCell.translatesAutoresizingMaskIntoConstraints = false
        secondRowSecondCell.topAnchor.constraint(equalTo: self.thirdSplittedRow.topAnchor).isActive = true
        secondRowSecondCell.heightAnchor.constraint(equalTo: self.secondRow.heightAnchor).isActive = true
        secondRowSecondCell.widthAnchor.constraint(equalTo: self.thirdSplittedRow.widthAnchor, multiplier: 0.3).isActive = true
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
        
        coordinatesLabel.translatesAutoresizingMaskIntoConstraints = false
        coordinatesLabel.topAnchor.constraint(equalTo: secondSplittedRow.topAnchor).isActive = true
        coordinatesLabel.centerXAnchor.constraint(equalTo: self.firstRowFirstCell.centerXAnchor).isActive = true
        coordinatesLabel.centerYAnchor.constraint(equalTo: self.secondSplittedRow.centerYAnchor).isActive = true
        
        coordinatesImage.translatesAutoresizingMaskIntoConstraints = false
        coordinatesImage.leadingAnchor.constraint(equalTo: self.firstRowFirstCell.leadingAnchor, constant: 20).isActive = true
        coordinatesImage.centerYAnchor.constraint(equalTo: self.secondSplittedRow.centerYAnchor).isActive = true
        
        magnitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        magnitudeLabel.topAnchor.constraint(equalTo: secondSplittedRow.topAnchor).isActive = true
        magnitudeLabel.centerXAnchor.constraint(equalTo: self.firstRowSecondCell.centerXAnchor).isActive = true
        magnitudeLabel.centerYAnchor.constraint(equalTo: self.secondSplittedRow.centerYAnchor).isActive = true
        
        magnitudeImage.translatesAutoresizingMaskIntoConstraints = false
        magnitudeImage.leadingAnchor.constraint(equalTo: self.firstRowSecondCell.leadingAnchor, constant: 0).isActive = true
        magnitudeImage.centerYAnchor.constraint(equalTo: self.secondSplittedRow.centerYAnchor).isActive = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: thirdSplittedRow.topAnchor).isActive = true
        dateLabel.centerXAnchor.constraint(equalTo: self.secondRowFirstCell.centerXAnchor).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: self.thirdSplittedRow.centerYAnchor).isActive = true
        
        dateImage.translatesAutoresizingMaskIntoConstraints = false
        dateImage.leadingAnchor.constraint(equalTo: self.secondRowFirstCell.leadingAnchor, constant: 20).isActive = true
        dateImage.centerYAnchor.constraint(equalTo: self.thirdSplittedRow.centerYAnchor).isActive = true
        
        depthLabel.translatesAutoresizingMaskIntoConstraints = false
        depthLabel.topAnchor.constraint(equalTo: thirdSplittedRow.topAnchor).isActive = true
        depthLabel.centerXAnchor.constraint(equalTo: self.secondRowSecondCell.centerXAnchor).isActive = true
        depthLabel.centerYAnchor.constraint(equalTo: self.thirdSplittedRow.centerYAnchor).isActive = true
        
        depthImage.translatesAutoresizingMaskIntoConstraints = false
        depthImage.leadingAnchor.constraint(equalTo: self.secondRowSecondCell.leadingAnchor, constant: 0).isActive = true
        depthImage.centerYAnchor.constraint(equalTo: self.thirdSplittedRow.centerYAnchor).isActive = true
    }
}
