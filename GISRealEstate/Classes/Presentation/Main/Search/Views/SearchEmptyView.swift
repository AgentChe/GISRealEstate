//
//  SearchEmptyView.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 26.06.2025.
//

import UIKit

final class SearchEmptyView: UIView {
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.5))
        .font(Fonts.PublicSans.regular(size: 16.scale))
        .lineHeight(20.scale)
        .textAlignment(.center)
    
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
extension SearchEmptyView {
    func update(proposedTab: SearchProposedPickerView.Tab) {
        imageView.image = {
            switch proposedTab {
            case .recentSearches:
                return UIImage(named: "Search.Empty.RecentSearches")
            case .favorites:
                return UIImage(named: "Search.Empty.Favorites")
            }
        }()
        
        label.attributedText = {
            switch proposedTab {
            case .recentSearches:
                return "Search.Empty.RecentSearches".localized.attributed(with: attrs)
            case .favorites:
                return "Search.Empty.Favorites".localized.attributed(with: attrs)
            }
        }()
    }
}

// MARK: Private
private extension SearchEmptyView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension SearchEmptyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 156.scale),
            imageView.heightAnchor.constraint(equalToConstant: 170.scale),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SearchEmptyView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
