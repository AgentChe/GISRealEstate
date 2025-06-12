//
//  MapView.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

import UIKit
import MapKit

final class MapView: UIView {
    lazy var mapKitView = makeMapKitView()
    lazy var searchAddressField = makeSearchAddressField()
    lazy var settingsButton = makeSettingsButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MapView {
    func setup(coordinate: Coordinate) {
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: coordinate.lat,
                longitude: coordinate.lon
            ),
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )
        mapKitView.setRegion(region, animated: true)
    }
}

// MARK: Private
private extension MapView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
}

// MARK: Make constraints
private extension MapView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            mapKitView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapKitView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapKitView.topAnchor.constraint(equalTo: topAnchor),
            mapKitView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            searchAddressField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            searchAddressField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -56.scale),
            searchAddressField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 2.scale)
        ])
        
        NSLayoutConstraint.activate([
            settingsButton.widthAnchor.constraint(equalToConstant: 24.scale),
            settingsButton.heightAnchor.constraint(equalToConstant: 24.scale),
            settingsButton.centerYAnchor.constraint(equalTo: searchAddressField.centerYAnchor),
            settingsButton.leadingAnchor.constraint(equalTo: searchAddressField.trailingAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MapView {
    func makeMapKitView() -> MKMapView {
        let view = MKMapView()
        view.showsUserLocation = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSearchAddressField() -> MapSearchField {
        let view = MapSearchField()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSettingsButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Map.Settings"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
