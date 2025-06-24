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
    
    private var authorizationQuery: LocationAuthorizationQuery?
    
    override init() {
        super.init()
        
        manager.delegate = self
    }
}

// MARK: Public
extension LocationQuery {
    func request() {
        let authorizationQuery = LocationAuthorizationQuery { [weak self] status in
            guard let self else { return }
            
            switch status {
            case .authorized:
                if let location = manager.location {
                    let coordinate = Coordinate(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                    onCoordinate?(coordinate)
                } else {
                    manager.requestLocation()
                }
            case .denied:
                onCoordinate?(nil)
            }
            
            self.authorizationQuery = nil
        }
        self.authorizationQuery = authorizationQuery
        authorizationQuery.request()
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
}
