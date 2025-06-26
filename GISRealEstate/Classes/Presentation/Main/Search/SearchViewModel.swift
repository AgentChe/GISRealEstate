//
//  SearchViewModel.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 25.06.2025.
//

import RxSwift
import RxCocoa

final class SearchViewModel {
    enum Action {
        case searchAddress(String)
        case searchCoordinate(Coordinate)
    }
    
    private lazy var firstPageActivity = RxActivityIndicator()
    private lazy var paginationActivity = RxActivityIndicator()
    
    private lazy var realtyManager = RealtyManager()
}

// MARK: Pubic
extension SearchViewModel {
    struct Input {
        let didSelectProposedTab: Signal<SearchProposedPickerView.Tab>
        let didScrollToBottom: Signal<Void>
        let didSelect: Signal<SearchTableElement>
        let didSearch: Signal<String>
    }
    
    struct Output {
        let proposedTab: Driver<SearchProposedPickerView.Tab>
        let firstPageActivity: Driver<Bool>
        let paginationActivity: Driver<Bool>
        let elements: Driver<[SearchTableElement]>
        let emptyHidden: Driver<Bool>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        let firstPageActivity = firstPageActivity.asDriver()
        let proposedTab = makeProposedTab(didSelectProposedTab: input.didSelectProposedTab)
        let elements = makeElements(
            proposedTab: proposedTab,
            didScrollToBottom: input.didScrollToBottom
        )
        
        return Output(
            proposedTab: proposedTab,
            firstPageActivity: firstPageActivity,
            paginationActivity: paginationActivity.asDriver(),
            elements: elements,
            emptyHidden: makeEmptyHidden(
                elements: elements,
                firstPageActivity: firstPageActivity
            ),
            action: makeAction(
                didSelect: input.didSelect,
                didSearch: input.didSearch
            )
        )
    }
}

// MARK: Private
private extension SearchViewModel {
    func makeAction(
        didSelect: Signal<SearchTableElement>,
        didSearch: Signal<String>
    ) -> Driver<Action> {
        Signal
            .merge(
                didSelect.map { element -> Action in
                    switch element.source {
                    case .address(let address):
                        return .searchAddress(address)
                    case .coordinate(let coordinate):
                        return .searchCoordinate(coordinate)
                    }
                },
                didSearch.map { Action.searchAddress($0) }
            )
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeEmptyHidden(elements: Driver<[SearchTableElement]>, firstPageActivity: Driver<Bool>) -> Driver<Bool> {
        Driver
            .combineLatest(elements, firstPageActivity) { elements, firstPageActivity -> Bool in
                if firstPageActivity {
                    return true
                }
                
                return !elements.isEmpty
            }
    }
    
    func makeProposedTab(didSelectProposedTab: Signal<SearchProposedPickerView.Tab>) -> Driver<SearchProposedPickerView.Tab> {
        didSelectProposedTab
            .asDriver(onErrorDriveWith: .never())
            .startWith(.recentSearches)
            .distinctUntilChanged()
    }
    
    func makeElements(proposedTab: Driver<SearchProposedPickerView.Tab>, didScrollToBottom: Signal<Void>) -> Driver<[SearchTableElement]> {
        proposedTab
            .flatMapLatest { [weak self] proposedTab -> Driver<[SearchTableElement]> in
                guard let self else { return .never() }
                
                switch proposedTab {
                case .recentSearches:
                    return downloadHistoryItemsPage(didScrollToBottom: didScrollToBottom)
                        .scan([]) { currentElements, page -> [SearchTableElement] in
                            let loadedElements = page.elements.compactMap { SearchTableElement(historyItem: $0) }
                            return page.info.current == 1 ? loadedElements : (currentElements + loadedElements)
                        }
                        .startWith([])
                case .favorites:
                    return downloadFavoriteItemsPage(didScrollToBottom: didScrollToBottom)
                        .scan([]) { currentElements, page -> [SearchTableElement] in
                            let loadedElements = page.elements.compactMap { SearchTableElement(favoriteItem: $0) }
                            return page.info.current == 1 ? loadedElements : (currentElements + loadedElements)
                        }
                        .startWith([])
                }
            }
    }
    
    func downloadHistoryItemsPage(didScrollToBottom: Signal<Void>) -> Driver<Page<[RealtyHistoryItem]>> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int) -> Driver<Page<[RealtyHistoryItem]>> {
            realtyManager
                .obtainHistoryItems(page: page)
                .trackActivity(page == 1 ? firstPageActivity : paginationActivity)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 }
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let firstPage = fetch(page: 1)
        let downloadedPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<[RealtyHistoryItem]>> in
                didScrollToBottom
                    .compactMap { lastPageInfo }
                    .filter { ($0.next <= $0.total) && ($0.current != $0.total) }
                    .flatMapFirst { lastPageInfo -> Driver<Page<[RealtyHistoryItem]>> in
                        fetch(page: lastPageInfo.next)
                    }
                    .startWith(firstPage)
            }
        
        return downloadedPage
    }
    
    func downloadFavoriteItemsPage(didScrollToBottom: Signal<Void>) -> Driver<Page<[RealtyFavoriteItem]>> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int) -> Driver<Page<[RealtyFavoriteItem]>> {
            realtyManager
                .obtainFavoriteItems(page: page)
                .trackActivity(page == 1 ? firstPageActivity : paginationActivity)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 }
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let firstPage = fetch(page: 1)
        let downloadedPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<[RealtyFavoriteItem]>> in
                didScrollToBottom
                    .compactMap { lastPageInfo }
                    .filter { ($0.next <= $0.total) && ($0.current != $0.total) }
                    .flatMapFirst { lastPageInfo -> Driver<Page<[RealtyFavoriteItem]>> in
                        fetch(page: lastPageInfo.next)
                    }
                    .startWith(firstPage)
            }
        
        return downloadedPage
    }
}
