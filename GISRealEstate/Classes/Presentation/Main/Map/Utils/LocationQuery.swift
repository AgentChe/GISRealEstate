//
//  LocationQuery.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

import CoreLocation

final class LocationQuery: NSObject {
    var onCoordinate: ((Coordinate?) -> Void)?
    
    private lazy var manager = CLLocationManager()
    
    override init() {
        super.init()
        
        manager.delegate = self
    }
}

// MARK: Public
extension LocationQuery {
    func request() {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            if let location = manager.location {
                let coordinate = Coordinate(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                onCoordinate?(coordinate)
            } else {
                manager.requestLocation()
            }
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            onCoordinate?(nil)
        }
    }
}

// MARK: CLLocationManagerDelegate
extension LocationQuery: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let coordinate = Coordinate(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        onCoordinate?(coordinate)
        
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        onCoordinate?(nil)
        
        manager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        request()
    }
}
