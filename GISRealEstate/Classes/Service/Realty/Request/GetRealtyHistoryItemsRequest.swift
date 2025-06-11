//
//  GetRealtyHistoryItemsRequest.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

import Alamofire

struct GetRealtyHistoryItemsRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let page: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/realty/history"
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
