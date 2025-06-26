//
//  MapViewModel.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

import RxSwift
import RxCocoa

final class MapViewModel {
    enum Action {
        case openSettings
        case moveToMyGeo
        case enableLocation
        case searchManually
        case searchCoordinate(Coordinate)
    }
}

// MARK: Public
extension MapViewModel {
    struct Input {
        let didTapSettings: Signal<Void>
        let didTapMyGeo: Signal<Void>
        let didTapEnableLocation: Signal<Void>
        let didTapSearch: Signal<Void>
        let didSelectCoordinate: Signal<Coordinate>
    }
    
    struct Output {
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(
                didTapSettings: input.didTapSettings,
                didTapMyGeo: input.didTapMyGeo,
                didTapEnableLocation: input.didTapEnableLocation,
                didTapSearch: input.didTapSearch,
                didSelectCoordinate: input.didSelectCoordinate
            )
        )
    }
}

// MARK: Private
private extension MapViewModel {
    func makeAction(
        didTapSettings: Signal<Void>,
        didTapMyGeo: Signal<Void>,
        didTapEnableLocation: Signal<Void>,
        didTapSearch: Signal<Void>,
        didSelectCoordinate: Signal<Coordinate>
    ) -> Driver<Action> {
        let openSettings = didTapSettings
            .map { Action.openSettings }
            .asDriver(onErrorDriveWith: .never())
        
        let moveToMyGeo = didTapMyGeo
            .map { Action.moveToMyGeo }
            .asDriver(onErrorDriveWith: .never())
        
        let enableLocation = didTapEnableLocation
            .map { Action.enableLocation }
            .asDriver(onErrorDriveWith: .never())
        
        let searchManually = didTapSearch
            .map { Action.searchManually }
            .asDriver(onErrorDriveWith: .never())
        
        let searchCoordinate = didSelectCoordinate
            .map { Action.searchCoordinate($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(
                openSettings,
                moveToMyGeo,
                enableLocation,
                searchManually,
                searchCoordinate
            )
    }
}
