//
//  MapView.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class MapView: UIView {
    enum Mode {
        case map, noLocationAccess
    }
    
    lazy var container = makeContainer()
    lazy var settingsButton = makeSettingsButton()
    lazy var searchPlaceholderView = makeSearchPlaceholderView()
    
    private var mapKitView: MapKitView?
    
    private lazy var didTapMyGeoTrigger = PublishRelay<Void>()
    private lazy var didTapEnableLocationTrigger = PublishRelay<Void>()
    private lazy var didSelectCoordinateTrigger = PublishRelay<Coordinate>()
    
    private lazy var disposables = [Disposable]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MapView {
    func setup(mode: Mode) {
        container.subviews.forEach { $0.removeFromSuperview() }
        
        disposables.forEach { $0.dispose() }
        disposables = []
        
        searchPlaceholderView.isHidden = mode != .map
        
        let view: UIView = {
            switch mode {
            case .map:
                let view = MapKitView()
                mapKitView = view
                
                let myGeoDisposable = view.myGeoButton.rx.tap.asSignal()
                    .emit(to: didTapMyGeoTrigger)
                disposables.append(myGeoDisposable)
                
                let selectCoordinateDisposable = view.didSelectCoordinate
                    .emit(to: didSelectCoordinateTrigger)
                disposables.append(selectCoordinateDisposable)
                
                return view
            case .noLocationAccess:
                let view = MapNoLocationAccessView()
                
                let disposable = view.openSettings.rx.tap.asSignal()
                    .emit(to: didTapEnableLocationTrigger)
                disposables.append(disposable)
                
                return view
            }
        }()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            view.topAnchor.constraint(equalTo: container.topAnchor),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        layoutIfNeeded()
    }
    
    func setup(myGeo: Coordinate) {
        mapKitView?.setup(coordinate: myGeo)
    }
    
    var didTapMyGeo: Signal<Void> {
        didTapMyGeoTrigger.asSignal()
    }
    
    var didTapEnableLocation: Signal<Void> {
        didTapEnableLocationTrigger.asSignal()
    }
    
    var didSelectCoordinate: Signal<Coordinate> {
        didSelectCoordinateTrigger.asSignal()
    }
}

// MARK: Private
private extension MapView {
    func initialize() {
        backgroundColor = Appearance.main300
    }
}

// MARK: Make constraints
private extension MapView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            settingsButton.widthAnchor.constraint(equalToConstant: 56.scale),
            settingsButton.heightAnchor.constraint(equalToConstant: 56.scale),
            settingsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            settingsButton.topAnchor.constraint(equalTo: topAnchor, constant: 68.scale)
        ])
        
        NSLayoutConstraint.activate([
            searchPlaceholderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchPlaceholderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchPlaceholderView.bottomAnchor.constraint(equalTo: bottomAnchor),
            searchPlaceholderView.heightAnchor.constraint(equalToConstant: 116.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MapView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main300
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSettingsButton() -> MapActionButton {
        let view = MapActionButton(imageName: "Map.Settings")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSearchPlaceholderView() -> MapSearchPlaceholderView {
        let view = MapSearchPlaceholderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
