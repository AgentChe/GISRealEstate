//
//  MapSearchPlaceholderView.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 25.06.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class MapSearchPlaceholderView: UIView {
    lazy var grabber = makeGrabber()
    lazy var swipeView = makeSwipeView()
    lazy var container = makeContainer()
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    
    private lazy var didTapSearchTrigger = PublishRelay<Void>()
    
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
extension MapSearchPlaceholderView {
    var didTapSearch: Signal<Void> {
        didTapSearchTrigger.asSignal()
    }
}

// MARK: Private
private extension MapSearchPlaceholderView {
    func initialize() {
        backgroundColor = Appearance.main300
        layer.cornerRadius = 20.scale
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let swipeGesture = UISwipeGestureRecognizer()
        swipeGesture.direction = .up
        swipeView.isUserInteractionEnabled = true
        swipeView.addGestureRecognizer(swipeGesture)
        let swipeDisposable = swipeGesture.rx.event
            .map { _ in Void() }
            .bind(to: didTapSearchTrigger)
        disposables.append(swipeDisposable)
        
        let tapGesture = UITapGestureRecognizer()
        container.isUserInteractionEnabled = true
        container.addGestureRecognizer(tapGesture)
        let tapDisposable = tapGesture.rx.event
            .map { _ in Void() }
            .bind(to: didTapSearchTrigger)
        disposables.append(tapDisposable)
    }
}

// MARK: Make constraints
private extension MapSearchPlaceholderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            grabber.widthAnchor.constraint(equalToConstant: 36.scale),
            grabber.heightAnchor.constraint(equalToConstant: 5.scale),
            grabber.centerXAnchor.constraint(equalTo: centerXAnchor),
            grabber.topAnchor.constraint(equalTo: topAnchor, constant: 5.scale)
        ])
        
        NSLayoutConstraint.activate([
            swipeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            swipeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            swipeView.topAnchor.constraint(equalTo: topAnchor),
            swipeView.bottomAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            container.heightAnchor.constraint(equalToConstant: 48.scale),
            container.topAnchor.constraint(equalTo: topAnchor, constant: 26.scale)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10.scale),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension MapSearchPlaceholderView {
    func makeGrabber() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.custom60_60_67.withAlphaComponent(0.3)
        view.layer.cornerRadius = 2.5.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSwipeView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 24.scale
        view.backgroundColor = Appearance.custom239_241_246
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Map.Search")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.5))
            .font(Fonts.PublicSans.regular(size: 16.scale))
            .lineHeight(20.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Map.SearchPlaceholder.Text".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
