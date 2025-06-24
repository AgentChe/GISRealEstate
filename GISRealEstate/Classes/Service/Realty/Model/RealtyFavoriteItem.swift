//
//  RealtyFavoriteItem.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 24.06.2025.
//

struct RealtyFavoriteItem {
    let id: String
    let address: String?
    let coordinates: Coordinate?
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? String else { return nil }
        
        self.id = id
        self.address = json["address"] as? String
        self.coordinates = {
            guard let coordinateJSON = json["coordinates"] as? [String: Any] else { return nil }
            
            return Coordinate(json: coordinateJSON)
        }()
    }
}

// MARK: Public
extension RealtyFavoriteItem {
    static func map(response: Any) -> Page<[RealtyFavoriteItem]>? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let itemsArray = body["items"] as? [[String: Any]],
            let pageInfoJSON = body["pagination"] as? [String: Any],
            let pageInfo = PageInfo(json: pageInfoJSON)
        else { return nil }
        
        let items = itemsArray.compactMap { RealtyFavoriteItem(json: $0) }
        
        return Page(info: pageInfo, elements: items)
    }
}
