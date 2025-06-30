//
//  RealtySearchResultSection.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

import Foundation

struct RealtySearchResultSection {
    let title: String
    let items: [String: String]
    let paid: Bool
    let icon: URL
    
    init?(json: [String: Any]) {
        guard
            let title = json["title"] as? String,
            let paid = json["paid"] as? Bool
        else { return nil }
        
        let icon: URL? = {
            guard let iconString = json["icon"] as? String else { return nil }
            return URL(string: iconString)
        }()
        guard let icon else { return nil }
        
        self.title = title
        self.items = {
            guard let itemsJSON = json["items"] as? [String: Any] else { return [:] }
            
            var result = [String: String]()
            
            itemsJSON.forEach { key, value in
                if let string = value as? String {
                    result[key] = string
                } else if let int = value as? Int {
                    result[key] = String(int)
                }
            }
            
            return result
        }()
        self.paid = paid
        self.icon = icon
    }
}
