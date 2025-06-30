//
//  RealtySearchResult.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 28.06.2025.
//

struct RealtySearchResult {
    let sections: [RealtySearchResultSection]
    let favoriteId: FavoriteId?
    
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let sectionsArray = body["sections"] as? [[String: Any]]
        else { return nil }
        
        sections = sectionsArray.compactMap { RealtySearchResultSection(json: $0) }
        favoriteId = {
            guard let id = body["favorite_id"] as? String else { return nil }
            return FavoriteId(id: id)
        }()
    }
}
