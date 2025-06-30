//
//  FavoriteId.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 30.06.2025.
//

struct FavoriteId {
    let id: String
    
    init(id: String) {
        self.id = id
    }
    
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let id = body["favorite_id"] as? String
        else { return nil }
        
        self.id = id
    }
}
