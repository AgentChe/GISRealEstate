//
//  AddFavoriteRequest.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 24.06.2025.
//

import Alamofire

struct AddFavoriteRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let address: String?
    let lat: Double?
    let lon: Double?
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/favorites/add"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var headers: Alamofire.HTTPHeaders? {
        [
            "Access-Token": GlobalDefinitions.apiKey
        ]
    }
    
    var parameters: Parameters? {
        [
            "anonymous_id": anonymousId,
            "internal_id": internalId,
            "address": address ?? NSNull(),
            "coordinates": {
                guard let lat, let lon else { return NSNull() }
                return ["lat": lat, "lon": lon]
            }()
        ]
    }
}
