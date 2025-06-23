//
//  SettingsViewModel.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

import RxSwift
import RxCocoa

final class SettingsViewModel {
    enum Action {
        case openHistory
        case openUrl(URL)
    }
}

// MARK: Public
extension SettingsViewModel {
    struct Input {
        let didTapHistory: Signal<Void>
        let didTapLink: Signal<SettingsLinkButton.Link>
    }
    
    struct Output {
        let elements: Driver<[SettingsTableElement]>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            elements: makeElements(),
            action: makeAction(
                didTapHistory: input.didTapHistory,
                didTapLink: input.didTapLink
            )
        )
    }
}

// MARK: Private
private extension SettingsViewModel {
    func makeElements() -> Driver<[SettingsTableElement]> {
        .deferred { .just([.history, .links]) }
    }
    
    func makeAction(
        didTapHistory: Signal<Void>,
        didTapLink: Signal<SettingsLinkButton.Link>
    ) -> Driver<Action> {
        let openHistory = didTapHistory
            .map { Action.openHistory }
            .asDriver(onErrorDriveWith: .never())
        
        let openUrl = didTapLink
            .map { link -> URL in
                switch link {
                case .contactUs:
                    return GlobalDefinitions.contactUsUrl
                case .termsOfUse:
                    return GlobalDefinitions.termsOfServiceUrl
                case .privacyPolicy:
                    return GlobalDefinitions.privacyPolicyUrl
                }
            }
            .map { Action.openUrl($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(openHistory, openUrl)
    }
}
