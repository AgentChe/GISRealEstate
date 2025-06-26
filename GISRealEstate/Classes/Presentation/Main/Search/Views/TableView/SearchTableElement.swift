//
//  SearchTableElement.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 25.06.2025.
//

struct SearchTableElement {
    enum Source {
        case address(String)
        case coordinate(Coordinate)
    }
    
    let id: String
    let address: String
    let source: Source
    
    init?(historyItem: RealtyHistoryItem) {
        let address: String? = {
            if let address = historyItem.address {
                return address
            } else if let coordinates = historyItem.coordinates {
                // TODO: проверить формат
                return String(format: "%.2f, %.2f", coordinates.lat, coordinates.lon)
            }
            
            return nil
        }()
        guard let address else { return nil }
        
        let source: Source? = {
            if let address = historyItem.address {
                return .address(address)
            } else if let coordinates = historyItem.coordinates {
                return .coordinate(coordinates)
            }
            
            return nil
        }()
        guard let source else { return nil }
        
        self.id = historyItem.id
        self.address = address
        self.source = source
    }
    
    init?(favoriteItem: RealtyFavoriteItem) {
        let address: String? = {
            if let address = favoriteItem.address {
                return address
            } else if let coordinates = favoriteItem.coordinates {
                // TODO: проверить формат
                return String(format: "%.2f, %.2f", coordinates.lat, coordinates.lon)
            }
            
            return nil
        }()
        guard let address else { return nil }
        
        let source: Source? = {
            if let address = favoriteItem.address {
                return .address(address)
            } else if let coordinates = favoriteItem.coordinates {
                return .coordinate(coordinates)
            }
            
            return nil
        }()
        guard let source else { return nil }
        
        self.id = favoriteItem.id
        self.address = address
        self.source = source
    }
}
