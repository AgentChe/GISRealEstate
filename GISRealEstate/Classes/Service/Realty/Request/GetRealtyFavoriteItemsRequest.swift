//
//  GetRealtyFavoriteItemsRequest.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 24.06.2025.
//

import Alamofire

struct GetRealtyFavoriteItemsRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let page: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/favorites"
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
            "page": page
        ]
    }
}
