//
//  SettingsViewController.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingsViewController: UIViewController {
    private lazy var mainView = SettingsView()
    
    private lazy var viewModel = SettingsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let didTapLink = Signal
            .merge(
                mainView.termsOfUseButton.rx.tap
                    .map { SettingsLinkButton.Link.termsOfUse }
                    .asSignal(onErrorSignalWith: .never()),
                
                mainView.privacyPolicyButton.rx.tap
                    .map { SettingsLinkButton.Link.privacyPolicy }
                    .asSignal(onErrorSignalWith: .never()),
                
                mainView.contactUsButton.rx.tap
                    .map { SettingsLinkButton.Link.contactUs }
                    .asSignal(onErrorSignalWith: .never())
            )
        
        let output = viewModel.configure(input: SettingsViewModel.Input(
            didTapLink: didTapLink
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension SettingsViewController {
    static func make() -> SettingsViewController {
        let vc = SettingsViewController()
        vc.navigationItem.title = "Settings.Title".localized
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension SettingsViewController {
    func action(_ action: SettingsViewModel.Action) {
        switch action {
        case .openUrl(let url):
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
