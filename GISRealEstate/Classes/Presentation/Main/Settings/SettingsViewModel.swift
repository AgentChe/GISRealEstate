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
        case openUrl(URL)
    }
}

// MARK: Public
extension SettingsViewModel {
    struct Input {
        let didTapLink: Signal<SettingsLinkButton.Link>
    }
    
    struct Output {
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(didTapLink: input.didTapLink)
        )
    }
}

// MARK: Private
private extension SettingsViewModel {
    func makeAction(didTapLink: Signal<SettingsLinkButton.Link>) -> Driver<Action> {
        didTapLink
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
    }
}
