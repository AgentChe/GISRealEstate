//
//  SettingsView.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

import UIKit

final class SettingsView: UIView {
    lazy var tableView = makeTableView()
    
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
private extension SettingsView {
    func initialize() {
        backgroundColor = Appearance.mono100
    }
}

// MARK: Make constraints
private extension SettingsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsView {
    func makeTableView() -> SettingsTableView {
        let view = SettingsTableView()
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets()
        view.setContentOffset(CGPoint.zero, animated: false)
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
