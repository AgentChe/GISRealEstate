//
//  SearchProposedPickerView.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 25.06.2025.
//

import UIKit
import RxCocoa

final class SearchProposedPickerView: UIView {
    enum Tab {
        case recentSearches, favorites
    }
    
    lazy var selector = makeSelector()
    lazy var recentSearchesButton = makeButton()
    lazy var favoriteButton = makeButton()
    
    private lazy var selectedAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.PublicSans.regular(size: 16.scale))
    private lazy var deselectedAttrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.4))
        .font(Fonts.PublicSans.regular(size: 16.scale))
    
    private lazy var selectorLeadingConstraint = NSLayoutConstraint()
    private lazy var selectorTrailingConstraint = NSLayoutConstraint()
    
    init() {
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        update(tab: .recentSearches, animate: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SearchProposedPickerView {
    func update(tab: Tab, animate: Bool = true) {
        NSLayoutConstraint.deactivate([
            selectorLeadingConstraint,
            selectorTrailingConstraint
        ])
        
        updateUI(tab: tab)
        updateLayout(tab: tab, animate: animate)
    }
    
    var didSelect: Signal<Tab> {
        Signal.merge(
            recentSearchesButton.rx.tap
                .map { Tab.recentSearches }
                .asSignal(onErrorSignalWith: .never()),
            
            favoriteButton.rx.tap
                .map { Tab.favorites }
                .asSignal(onErrorSignalWith: .never())
        )
    }
}

// MARK: Private
private extension SearchProposedPickerView {
    func initialize() {
        backgroundColor = Appearance.custom239_241_246
        layer.cornerRadius = 24.scale
        layer.masksToBounds = true
    }
    
    func updateUI(tab: Tab) {
        let recentAttrs = tab == .recentSearches ? selectedAttrs : deselectedAttrs
        recentSearchesButton.setAttributedTitle("Search.ProposedTab.RecentSearches".localized.attributed(with: recentAttrs), for: .normal)
        
        let favoritesAttrs = tab == .favorites ? selectedAttrs : deselectedAttrs
        favoriteButton.setAttributedTitle("Search.ProposedTab.Favorites".localized.attributed(with: favoritesAttrs), for: .normal)
    }
    
    func updateLayout(tab: Tab, animate: Bool) {
        switch tab {
        case .recentSearches:
            selectorLeadingConstraint = selector.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4.scale)
            selectorTrailingConstraint = selector.trailingAnchor.constraint(equalTo: centerXAnchor)
        case .favorites:
            selectorLeadingConstraint = selector.leadingAnchor.constraint(equalTo: centerXAnchor)
            selectorTrailingConstraint = selector.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4.scale)
        }
        
        NSLayoutConstraint.activate([
            selectorLeadingConstraint,
            selectorTrailingConstraint
        ])
        
        if animate {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.layoutIfNeeded()
            })
        } else {
            layoutIfNeeded()
        }
    }
}

// MARK: Make constraints
private extension SearchProposedPickerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            selector.topAnchor.constraint(equalTo: topAnchor, constant: 4.scale),
            selector.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.scale)
        ])
        
        NSLayoutConstraint.activate([
            recentSearchesButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            recentSearchesButton.trailingAnchor.constraint(equalTo: centerXAnchor),
            recentSearchesButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            favoriteButton.leadingAnchor.constraint(equalTo: centerXAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            favoriteButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SearchProposedPickerView {
    func makeSelector() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 20.scale
        view.backgroundColor = Appearance.mono100
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
