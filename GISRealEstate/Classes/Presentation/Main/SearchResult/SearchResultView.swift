//
//  SearchResultView.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 27.06.2025.
//

import UIKit

final class SearchResultView: UIView {
    lazy var grabber = makeGrabber()
    lazy var headerView = makeHeaderView()
    lazy var sectionsView = makeSectionsView()
    lazy var itemsView = makeItemsView()
    lazy var emptyView = makeEmptyView()
    lazy var preloader = makePreloader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension SearchResultView {
    func initialize() {
        backgroundColor = Appearance.main300
    }
}

// MARK: Make constraints
private extension SearchResultView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            grabber.widthAnchor.constraint(equalToConstant: 36.scale),
            grabber.heightAnchor.constraint(equalToConstant: 5.scale),
            grabber.centerXAnchor.constraint(equalTo: centerXAnchor),
            grabber.topAnchor.constraint(equalTo: topAnchor, constant: 5.scale)
        ])
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.topAnchor.constraint(equalTo: topAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            sectionsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sectionsView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 32.scale),
            sectionsView.heightAnchor.constraint(equalToConstant: 44.scale)
        ])
        
        NSLayoutConstraint.activate([
            itemsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            itemsView.topAnchor.constraint(equalTo: sectionsView.bottomAnchor),
            itemsView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.widthAnchor.constraint(equalToConstant: 257.scale),
            emptyView.heightAnchor.constraint(equalToConstant: 206.scale),
            emptyView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyView.topAnchor.constraint(equalTo: topAnchor, constant: 158.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.widthAnchor.constraint(equalToConstant: 45.scale),
            preloader.heightAnchor.constraint(equalToConstant: 45.scale),
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SearchResultView {
    func makeGrabber() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.custom60_60_67.withAlphaComponent(0.3)
        view.layer.cornerRadius = 2.5.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeHeaderView() -> SearchResultHeaderView {
        let view = SearchResultHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSectionsView() -> SRSectionsCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 8.scale
        
        let view = SRSectionsCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsHorizontalScrollIndicator = false
        view.setContentOffset(CGPoint(x: 16.scale, y: 0), animated: false)
        view.contentInset = UIEdgeInsets(horizontal: 16.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeItemsView() -> SRItemsTableView {
        let view = SRItemsTableView()
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets(vertical: 16.scale)
        view.setContentOffset(CGPoint(x: 0, y: -16.scale), animated: false)
        view.separatorColor = Appearance.custom199_203_209
        view.separatorInset = UIEdgeInsets(horizontal: 16.scale)
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmptyView() -> SearchResultEmptyView {
        let view = SearchResultEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = Appearance.mono200
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
