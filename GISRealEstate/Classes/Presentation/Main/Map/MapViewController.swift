//
//  MapViewController.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

import UIKit
import RxSwift

final class MapViewController: UIViewController {
    private lazy var mainView = MapView()
    
    private lazy var viewModel = MapViewModel()
    
    private let requestReview: Bool
    
    private var locationAuthorizationQuery: LocationAuthorizationQuery?
    private lazy var locationQuery = LocationQuery()
    
    private lazy var disposeBag = DisposeBag()
    
    private init(requestReview: Bool) {
        self.requestReview = requestReview
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationQuery.onCoordinate = { [weak self] coordinate in
            guard let coordinate else { return }
            
            self?.mainView.setup(myGeo: coordinate)
        }
        
        let output = viewModel.configure(input: MapViewModel.Input(
            didTapSettings: mainView.settingsButton.rx.tap.asSignal(),
            didTapMyGeo: mainView.didTapMyGeo,
            didTapEnableLocation: mainView.didTapEnableLocation,
            didTapSearch: mainView.searchPlaceholderView.didTapSearch,
            didSelectCoordinate: mainView.didSelectCoordinate
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        if requestReview {
            RequestReview.request()
        }
        
        determineAuthorizationStatus()
    }
}

// MARK: Public
extension MapViewController {
    static func make(requestReview: Bool) -> NavigationController {
        let vc = MapViewController(requestReview: requestReview)
        vc.navigationItem.backButtonTitle = " "
        
        return NavigationController(rootViewController: vc)
    }
}

// MARK: Private
private extension MapViewController {
    func action(_ action: MapViewModel.Action) {
        switch action {
        case .openSettings:
            let vc = SettingsViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .moveToMyGeo:
            locationQuery.request()
        case .enableLocation:
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case .searchManually:
            let vc = SearchViewController.make()
            present(vc, animated: true)
        case .searchCoordinate(let coordinate):
            break // TODO
        }
    }
    
    func determineAuthorizationStatus() {
        let locationAuthorizationQuery = LocationAuthorizationQuery { [weak self] status in
            guard let self else { return }
            
            switch status {
            case .authorized:
                mainView.setup(mode: .map)
                
                locationQuery.request()
            case .denied:
                mainView.setup(mode: .noLocationAccess)
            }
        }
        locationAuthorizationQuery.request()
    }
}
