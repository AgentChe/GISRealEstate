//
//  RealtyManager.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

import RxSwift

protocol RealtyManagerProtocol {
    func obtainHistoryItems(page: Int) -> Single<Page<[RealtyHistoryItem]>?>
    func searchRealty(
        address: String?,
        lat: Double?,
        lon: Double?
    ) -> Single<RealtySearchResult?>
    func obtainFavoriteItems(page: Int) -> Single<Page<[RealtyFavoriteItem]>?>
    func addFavorite(
        address: String?,
        lat: Double?,
        lon: Double?
    ) -> Single<FavoriteId?>
    func deleteFavorite(id: FavoriteId) -> Single<RequestResult>
    func favoritesClear() -> Single<RequestResult>
    func historyClear() -> Single<RequestResult>
}

final class RealtyManager {
    private lazy var restAPITransport = RestAPITransport()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: RealtyManagerProtocol
extension RealtyManager: RealtyManagerProtocol {
    func obtainHistoryItems(page: Int) -> Single<Page<[RealtyHistoryItem]>?> {
        let request = GetRealtyHistoryItemsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            page: page
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { RealtyHistoryItem.map(response: $0) }
    }
    
    func searchRealty(
        address: String? = nil,
        lat: Double? = nil,
        lon: Double? = nil
    ) -> Single<RealtySearchResult?> {
        let request = SearchRealtyRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            address: address,
            lat: lat,
            lon: lon
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { RealtySearchResult(response: $0) }
    }
    
    func obtainFavoriteItems(page: Int) -> Single<Page<[RealtyFavoriteItem]>?> {
        let request = GetRealtyFavoriteItemsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            page: page
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { RealtyFavoriteItem.map(response: $0) }
    }
    
    func addFavorite(
        address: String? = nil,
        lat: Double? = nil,
        lon: Double? = nil
    ) -> Single<FavoriteId?> {
        let request = AddFavoriteRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            address: address,
            lat: lat,
            lon: lon
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { FavoriteId(response: $0) }
    }
    
    func deleteFavorite(id: FavoriteId) -> Single<RequestResult> {
        let request = RemoveFavoriteRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id.id
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
    }
    
    func favoritesClear() -> Single<RequestResult> {
        let request = FavoritesClearRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
    }
    
    func historyClear() -> Single<RequestResult> {
        let request = HistoryClearRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
    }
}
