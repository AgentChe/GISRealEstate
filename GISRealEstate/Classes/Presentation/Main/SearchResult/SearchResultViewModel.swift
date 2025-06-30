//
//  SearchResultViewModel.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 27.06.2025.
//

import RxSwift
import RxCocoa

final class SearchResultViewModel {
    enum Action {
        case close
        case openPaygate
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private let parameter: Driver<Parameter>
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var realtyManager = RealtyManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(address: String) {
        parameter = BehaviorRelay(value: Parameter.address(address)).asDriver()
    }
    
    init(coordinate: Coordinate) {
        parameter = BehaviorRelay(value: Parameter.coordinate(coordinate)).asDriver()
    }
}

// MARK: Public
extension SearchResultViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didTapMark: Signal<FavoriteId?>
        let didSelectSection: Signal<SRSectionsCollectionElement>
    }
    
    struct Output {
        let title: Driver<String>
        let action: Driver<Action>
        let activity: Driver<Bool>
        let favorite: Driver<FavoriteId?>
        let emptyHidden: Driver<Bool>
        let sections: Driver<[SRSectionsCollectionElement]>
        let items: Driver<[SRItemsElement]>
    }
    
    func configure(input: Input) -> Output {
        let searchResult = makeSearchResult(parameter: parameter)
        let sections = makeSections(searchResult: searchResult)
        
        return Output(
            title: makeTitle(parameter: parameter),
            action: makeAction(
                didTapClose: input.didTapClose,
                didSelectSection: input.didSelectSection
            ),
            activity: activity.asDriver(),
            favorite: makeFavorite(
                searchResult: searchResult,
                didTapMark: input.didTapMark,
                parameter: parameter
            ),
            emptyHidden: makeEmptyHidden(searchResult: searchResult),
            sections: sections,
            items: makeItems(
                sections: sections,
                didSelectSection: input.didSelectSection
            )
        )
    }
}

// MARK: Private
private extension SearchResultViewModel {
    enum Parameter {
        case address(String)
        case coordinate(Coordinate)
    }
    
    func makeTitle(parameter: Driver<Parameter>) -> Driver<String> {
        parameter
            .map { parameter -> String in
                switch parameter {
                case .address(let address):
                    return address
                case .coordinate(let coordinate):
                    return String(format: "%.2f, %.2f", coordinate.lat, coordinate.lon)
                }
            }
    }
    
    func makeSections(searchResult: Driver<RealtySearchResult?>) -> Driver<[SRSectionsCollectionElement]> {
        searchResult
            .map { searchResult -> [SRSectionsCollectionElement] in
                guard let sections = searchResult?.sections else { return [] }
                
                let firstNonPaidIndex = sections.firstIndex(where: { !$0.paid })
                
                return sections.enumerated().map { index, section -> SRSectionsCollectionElement in
                    SRSectionsCollectionElement(
                        section: section,
                        selected: firstNonPaidIndex == index
                    )
                }
            }
    }
    
    func makeItems(
        sections: Driver<[SRSectionsCollectionElement]>,
        didSelectSection: Signal<SRSectionsCollectionElement>
    ) -> Driver<[SRItemsElement]> {
        let initial = sections
            .map { sections -> [SRItemsElement] in
                let dict = sections.first(where: { $0.selected })?.section.items ?? [:]
                return dict.map { key, value -> SRItemsElement in
                    SRItemsElement(title: key, value: value)
                }
            }
        
        let selected = didSelectSection
            .filter { section -> Bool in
                let needPayment = section.section.paid ? !SessionManager().hasActiveSubscriptions() : false
                return !needPayment
            }
            .map { $0.section.items.map { SRItemsElement(title: $0, value: $1) } }
            .asDriver(onErrorJustReturn: [])
        
        return Driver
            .merge(initial, selected)
            .map { $0.sorted(by: { $0.title < $1.title }) }
    }
    
    func makeAction(
        didTapClose: Signal<Void>,
        didSelectSection: Signal<SRSectionsCollectionElement>
    ) -> Driver<Action> {
        let close = didTapClose
            .map { Action.close }
            .asDriver(onErrorDriveWith: .never())
        
        let openPaygate = didSelectSection
            .compactMap { element -> Action? in
                guard element.section.paid else { return nil }
                
                return SessionManager().hasActiveSubscriptions() ? nil : .openPaygate
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(close, openPaygate)
    }
    
    func makeSearchResult(parameter: Driver<Parameter>) -> Driver<RealtySearchResult?> {
        parameter
            .flatMapLatest { [weak self] parameter -> Driver<RealtySearchResult?> in
                guard let self else { return .never() }
                
                switch parameter {
                case .address(let address):
                    return realtyManager
                        .searchRealty(address: address)
                        .trackActivity(activity)
                        .asDriver(onErrorJustReturn: nil)
                case .coordinate(let coordinate):
                    return realtyManager
                        .searchRealty(lat: coordinate.lat, lon: coordinate.lon)
                        .trackActivity(activity)
                        .asDriver(onErrorJustReturn: nil)
                }
            }
    }
    
    func makeFavorite(
        searchResult: Driver<RealtySearchResult?>,
        didTapMark: Signal<FavoriteId?>,
        parameter: Driver<Parameter>
    ) -> Driver<FavoriteId?> {
        let initial = searchResult.map { $0?.favoriteId }
        
        let action = didTapMark
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(parameter) { ($0, $1) }
            .withLatestFrom(searchResult) { ($0.0, $0.1, $1) }
            .flatMapLatest { [weak self] favoriteId, parameter, searchResult -> Driver<FavoriteId?> in
                guard let self else { return .never() }
                
                func source() -> Single<FavoriteId?> {
                    if let id = favoriteId {
                        return realtyManager.deleteFavorite(id: id)
                            .map { result -> FavoriteId? in
                                guard result.success else {
                                    throw ContentError(.notContent)
                                }
                                
                                return nil
                            }
                    } else {
                        let favoriteId: Single<FavoriteId?> = {
                            switch parameter {
                            case .address(let address):
                                return self.realtyManager.addFavorite(address: address)
                            case .coordinate(let coordinate):
                                return self.realtyManager.addFavorite(lat: coordinate.lat, lon: coordinate.lon)
                            }
                        }()
                        
                        return favoriteId
                            .map { favoriteId -> FavoriteId? in
                                guard let favoriteId else {
                                    throw ContentError(.notContent)
                                }
                                
                                return favoriteId
                            }
                    }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    self.tryAgain?(error) ?? .empty()
                }
                
                return self.observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver.merge(initial, action)
    }
    
    func makeEmptyHidden(searchResult: Driver<RealtySearchResult?>) -> Driver<Bool> {
        searchResult
            .map { !($0?.sections ?? []).isEmpty }
            .startWith(true)
    }
}
