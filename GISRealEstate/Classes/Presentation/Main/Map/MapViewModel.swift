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
    }
}

// MARK: Public
extension MapViewModel {
    struct Input {
        let didTapSettings: Signal<Void>
        let didTapMyGeo: Signal<Void>
        let didTapEnableLocation: Signal<Void>
    }
    
    struct Output {
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(
                didTapSettings: input.didTapSettings,
                didTapMyGeo: input.didTapMyGeo,
                didTapEnableLocation: input.didTapEnableLocation
            )
        )
    }
}

// MARK: Private
private extension MapViewModel {
    func makeAction(
        didTapSettings: Signal<Void>,
        didTapMyGeo: Signal<Void>,
        didTapEnableLocation: Signal<Void>
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
        
        return Driver
            .merge(openSettings, moveToMyGeo, enableLocation)
    }
}
