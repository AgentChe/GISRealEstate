//
//  SearchResultHeaderView.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 28.06.2025.
//

import UIKit
import RxCocoa

final class SearchResultHeaderView: UIView {
    lazy var label = makeLabel()
    lazy var favoriteButton = makeFavoriteButton()
    lazy var closeButton = makeCloseButton()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.PublicSans.bold(size: 18.scale))
        .lineHeight(30.scale)
        .textAlignment(.left)
    
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
extension SearchResultHeaderView {
    func setup(title: String) {
        label.attributedText = title.attributed(with: attrs)
    }
    
    func setup(favorite: Bool) {
        let iconName = favorite ? "SearchResult.Favorite.T" : "SearchResult.Favorite.F"
        favoriteButton.setImage(UIImage(named: iconName), for: .normal)
    }
    
    var didTapClose: Signal<Void> {
        closeButton.rx.tap.asSignal()
    }
}

// MARK: Private
private extension SearchResultHeaderView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension SearchResultHeaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -90.scale),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            favoriteButton.widthAnchor.constraint(equalToConstant: 24.scale),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24.scale),
            favoriteButton.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            favoriteButton.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            closeButton.leadingAnchor.constraint(equalTo: favoriteButton.trailingAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SearchResultHeaderView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFavoriteButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "SearchResult.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
