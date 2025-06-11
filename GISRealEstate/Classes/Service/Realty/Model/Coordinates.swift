//
//  Coordinates.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

struct Coordinates {
    let lat: Double
    let lon: Double
    
    init?(json: [String: Any]) {
        guard let lat = json["lat"] as? Double, let lon = json["lon"] as? Double else { return nil }
        
        self.lat = lat
        self.lon = lon
    }
}
