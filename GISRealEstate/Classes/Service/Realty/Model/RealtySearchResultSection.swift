//
//  RealtySearchResultSection.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

struct RealtySearchResultSection {
    let title: String
    let items: [String: String]
    let paid: Bool
    
    init?(json: [String: Any]) {
        guard
            let title = json["title"] as? String,
            let paid = json["paid"] as? Bool
        else { return nil }
        
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
    }
}

// MARK: Public
extension RealtySearchResultSection {
    static func map(response: Any) -> [RealtySearchResultSection] {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let sectionsArray = body["sections"] as? [[String: Any]]
        else { return [] }
        
        return sectionsArray.compactMap { RealtySearchResultSection(json: $0) }
    }
}
