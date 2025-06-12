//
//  MapViewController.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class MapViewController: UIViewController {
    private lazy var mainView = MapView()
    
    private lazy var viewModel = MapViewModel()
    
    private let requestReview: Bool
    
    private lazy var locationQuery = LocationQuery()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didSelectCoordinateTrigger = PublishRelay<Coordinate>()
    
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
            
            self?.mainView.setup(coordinate: coordinate)
        }
        locationQuery.request()
        
        let output = viewModel.configure(input: MapViewModel.Input(
            didSearchByAddress: mainView.searchAddressField.didTapSearch,
            didChangeSearchAddress: mainView.searchAddressField.changedText,
            didTapSettings: mainView.settingsButton.rx.tap.asSignal(),
            didSelectCoordinate: didSelectCoordinateTrigger.asSignal()
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        if requestReview {
            RequestReview.request()
        }
        
        addTapGestureOnMap()
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
        case .searchByAddress(let address):
            mainView.searchAddressField.setup(text: nil)
            
            let vc = RealtyViewController.make(address: address)
            navigationController?.pushViewController(vc, animated: true)
        case .searchByCoordinate(let coordinate):
            mainView.searchAddressField.setup(text: nil)
            
            let vc = RealtyViewController.make(coordinate: coordinate)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func addTapGestureOnMap() {
        let tapGesture = UITapGestureRecognizer()
        mainView.mapKitView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .bind(to: Binder(self) { base, gesture in
                base.mainView.endEditing(true)
                
                let point = gesture.location(in: base.mainView.mapKitView)
                let coord = base.mainView.mapKitView.convert(point, toCoordinateFrom: base.mainView.mapKitView)
                let coordinate = Coordinate(lat: coord.latitude, lon: coord.longitude)
                
                base.didSelectCoordinateTrigger.accept(coordinate)
            })
            .disposed(by: disposeBag)
    }
}
