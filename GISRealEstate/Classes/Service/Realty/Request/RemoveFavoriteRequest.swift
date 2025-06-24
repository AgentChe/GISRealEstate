//
//  RemoveFavoriteRequest.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 24.06.2025.
//

import Alamofire

struct RemoveFavoriteRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let id: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/favorites/remove"
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
            "item_id": id
        ]
    }
}
