//
//  SearchRealtyRequest.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

import Alamofire

struct SearchRealtyRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let address: String?
    let lat: Double?
    let lon: Double?
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/realty/search"
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
            "lat": lat ?? NSNull(),
            "lon": lon ?? NSNull()
        ]
    }
}
