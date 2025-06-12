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
        case searchByAddress(String)
        case searchByCoordinate(Coordinate)
    }
}

// MARK: Public
extension MapViewModel {
    struct Input {
        let didSearchByAddress: Signal<Void>
        let didChangeSearchAddress: Signal<String>
        let didTapSettings: Signal<Void>
        let didSelectCoordinate: Signal<Coordinate>
    }
    
    struct Output {
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(
                didSearchByAddress: input.didSearchByAddress,
                didChangeSearchAddress: input.didChangeSearchAddress,
                didTapSettings: input.didTapSettings,
                didSelectCoordinate: input.didSelectCoordinate
            )
        )
    }
}

// MARK: Private
private extension MapViewModel {
    func makeAction(
        didSearchByAddress: Signal<Void>,
        didChangeSearchAddress: Signal<String>,
        didTapSettings: Signal<Void>,
        didSelectCoordinate: Signal<Coordinate>
    ) -> Driver<Action> {
        let searchByAddress = didSearchByAddress
            .withLatestFrom(didChangeSearchAddress)
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .map { Action.searchByAddress($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let openSettings = didTapSettings
            .map { Action.openSettings }
            .asDriver(onErrorDriveWith: .never())
        
        let searchByCoordinate = didSelectCoordinate
            .map { Action.searchByCoordinate($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(searchByAddress, openSettings, searchByCoordinate)
    }
}
