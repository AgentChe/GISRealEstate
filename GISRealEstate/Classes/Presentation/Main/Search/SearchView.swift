//
//  SearchView.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 25.06.2025.
//

import UIKit

final class SearchView: UIView {
    lazy var grabber = makeGrabber()
    lazy var searchField = makeSearchField()
    lazy var proposedPickerView = makeProposedPickerView()
    lazy var tableView = makeTableView()
    lazy var emptyView = makeEmptyView()
    lazy var centerPreloader = makePreloader()
    lazy var tableBottomPreloader = makePreloader()
    
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
private extension SearchView {
    func initialize() {
        backgroundColor = Appearance.main300
    }
}

// MARK: Make constraints
private extension SearchView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            grabber.widthAnchor.constraint(equalToConstant: 36.scale),
            grabber.heightAnchor.constraint(equalToConstant: 5.scale),
            grabber.centerXAnchor.constraint(equalTo: centerXAnchor),
            grabber.topAnchor.constraint(equalTo: topAnchor, constant: 5.scale)
        ])
        
        NSLayoutConstraint.activate([
            searchField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            searchField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            searchField.topAnchor.constraint(equalTo: topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            proposedPickerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            proposedPickerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            proposedPickerView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 20.scale),
            proposedPickerView.heightAnchor.constraint(equalToConstant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: proposedPickerView.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.widthAnchor.constraint(equalToConstant: 257.scale),
            emptyView.heightAnchor.constraint(equalToConstant: 206.scale),
            emptyView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyView.topAnchor.constraint(equalTo: proposedPickerView.bottomAnchor, constant: 58.scale)
        ])
        
        NSLayoutConstraint.activate([
            centerPreloader.widthAnchor.constraint(equalToConstant: 45.scale),
            centerPreloader.heightAnchor.constraint(equalToConstant: 45.scale),
            centerPreloader.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            centerPreloader.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableBottomPreloader.widthAnchor.constraint(equalToConstant: 32.scale),
            tableBottomPreloader.heightAnchor.constraint(equalToConstant: 32.scale),
            tableBottomPreloader.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -8.scale),
            tableBottomPreloader.centerXAnchor.constraint(equalTo: tableView.centerXAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SearchView {
    func makeGrabber() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.custom60_60_67.withAlphaComponent(0.3)
        view.layer.cornerRadius = 2.5.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSearchField() -> SearchInputField {
        let view = SearchInputField()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProposedPickerView() -> SearchProposedPickerView {
        let view = SearchProposedPickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> SearchTableView {
        let view = SearchTableView()
        view.backgroundColor = UIColor.clear
        view.separatorStyle = .singleLine
        view.separatorColor = Appearance.custom199_203_209
        view.contentInset = UIEdgeInsets(vertical: 18.scale)
        view.showsVerticalScrollIndicator = false
        view.setContentOffset(CGPoint(x: 0, y: -18.scale), animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmptyView() -> SearchEmptyView {
        let view = SearchEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = Appearance.mono200
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
