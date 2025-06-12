//
//  RealtyViewModel.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

import RxSwift
import RxCocoa

final class RealtyViewModel {
    enum Action {
        case openPaygate
    }
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var realtyManager = RealtyManager()
    
    private let source: Driver<Source>
    
    init(address: String) {
        source = BehaviorRelay(value: Source.address(address)).asDriver()
    }
    
    init(coordinate: Coordinate) {
        source = BehaviorRelay(value: Source.coordinate(coordinate)).asDriver()
    }
}

// MARK: Public
extension RealtyViewModel {
    struct Input {
        let didTapPaidSection: Signal<Void>
    }
    
    struct Output {
        let sections: Driver<[RealtyTableSection]>
        let activity: Driver<Bool>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            sections: makeSections(
                searchResult: makeSearchResult(source: source),
                activeSubscription: makeActiveSubscription()
            ),
            activity: activity.asDriver(),
            action: makeAction(didTapPaidSection: input.didTapPaidSection)
        )
    }
}

// MARK: Private
private extension RealtyViewModel {
    enum Source {
        case address(String)
        case coordinate(Coordinate)
    }
    
    func makeAction(didTapPaidSection: Signal<Void>) -> Driver<Action> {
        let openPaygate = didTapPaidSection
            .map { Action.openPaygate }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(openPaygate)
    }
    
    func makeSections(
        searchResult: Driver<[RealtySearchResultSection]>,
        activeSubscription: Driver<Bool>
    ) -> Driver<[RealtyTableSection]> {
        Driver
            .combineLatest(searchResult, activeSubscription)
            .map { searchResult, activeSubscription -> [RealtyTableSection] in
                var sections = [RealtyTableSection]()
                
                searchResult.forEach { block in
                    let isAvailable = activeSubscription ? true : !block.paid
                    
                    let title = RealtyTableTitleElement(
                        title: block.title,
                        isAvailable: isAvailable,
                        corner: isAvailable ? .top : .all
                    )
                    
                    let items: [RealtyTableItemElement] = {
                        guard isAvailable else { return [] }
                        
                        let itemsCount = block.items.count
                        
                        return block.items
                            .sorted { l, r -> Bool in
                                l.key < r.key
                            }
                            .enumerated()
                            .map { index, args -> RealtyTableItemElement in
                                RealtyTableItemElement(
                                    title: args.key,
                                    value: args.value,
                                    corner: (index == (itemsCount - 1)) ? .bottom : .none
                                )
                            }
                    }()
                    
                    let elements: [RealtyTableElement] = [.title(title)] + items.map { .item($0) }
                    let section = RealtyTableSection(elements: elements)
                    
                    sections.append(section)
                }
                
                return sections
            }
    }
    
    func makeSearchResult(source: Driver<Source>) -> Driver<[RealtySearchResultSection]> {
        source
            .flatMapLatest { [weak self] source -> Driver<[RealtySearchResultSection]> in
                guard let self else { return .never() }
                
                switch source {
                case .address(let address):
                    return realtyManager
                        .searchRealty(address: address)
                        .trackActivity(activity)
                        .asDriver(onErrorJustReturn: [])
                case .coordinate(let coordinate):
                    return realtyManager
                        .searchRealty(lat: coordinate.lat, lon: coordinate.lon)
                        .trackActivity(activity)
                        .asDriver(onErrorJustReturn: [])
                }
            }
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .asDriver(onErrorDriveWith: .never())
            .map { SessionManager().hasActiveSubscriptions() }
            .startWith(SessionManager().hasActiveSubscriptions())
    }
}
