//
//  MapKitView.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 24.06.2025.
//

import UIKit
import MapKit

final class MapKitView: UIView {
    lazy var mapKitView = makeMapKitView()
    lazy var myGeoButton = makeMyGeoButton()
    
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
extension MapKitView {
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
private extension MapKitView {
    func initialize() {
        backgroundColor = Appearance.main300
    }
}

// MARK: Make constraints
private extension MapKitView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            mapKitView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapKitView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapKitView.topAnchor.constraint(equalTo: topAnchor),
            mapKitView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            myGeoButton.widthAnchor.constraint(equalToConstant: 56.scale),
            myGeoButton.heightAnchor.constraint(equalToConstant: 56.scale),
            myGeoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            myGeoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -140.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MapKitView {
    func makeMapKitView() -> MKMapView {
        let view = MKMapView()
        view.showsUserLocation = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeMyGeoButton() -> MapActionButton {
        let view = MapActionButton(imageName: "Map.MyGeo")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
