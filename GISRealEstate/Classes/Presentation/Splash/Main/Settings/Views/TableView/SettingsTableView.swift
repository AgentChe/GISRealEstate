//
//  SettingsTableView.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 12.06.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingsTableView: UITableView {
    private lazy var elements = [SettingsTableElement]()
    
    private lazy var didTapHistoryTrigger = PublishRelay<Void>()
    private lazy var didTapLinkTrigger = PublishRelay<SettingsLinkButton.Link>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SettingsTableView {
    func setup(elements: [SettingsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didTapHistory: Signal<Void> {
        didTapHistoryTrigger.asSignal()
    }
    
    var didTapLink: Signal<SettingsLinkButton.Link> {
        didTapLinkTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension SettingsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .history:
            return dequeueReusableCell(withIdentifier: String(describing: SettingsHistoryCell.self), for: indexPath)
        case .links:
            let cell = dequeueReusableCell(withIdentifier: String(describing: SettingsLinksCell.self), for: indexPath) as! SettingsLinksCell
            cell.didTapLink = { [weak self] link in
                self?.didTapLinkTrigger.accept(link)
            }
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension SettingsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case .history = elements[indexPath.row] else { return }
        
        didTapHistoryTrigger.accept(Void())
    }
}

// MARK: Private
private extension SettingsTableView {
    func initialize() {
        dataSource = self
        delegate = self
        
        register(SettingsHistoryCell.self, forCellReuseIdentifier: String(describing: SettingsHistoryCell.self))
        register(SettingsLinksCell.self, forCellReuseIdentifier: String(describing: SettingsLinksCell.self))
    }
}
