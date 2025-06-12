//
//  RealtyTableView.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class RealtyTableView: UITableView {
    private lazy var sections = [RealtyTableSection]()
    
    private lazy var didTapPaidSectionTrigger = PublishRelay<Void>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension RealtyTableView {
    func setup(sections: [RealtyTableSection]) {
        self.sections = sections
        
        reloadData()
    }
    
    var didTapPaidSection: Signal<Void> {
        didTapPaidSectionTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension RealtyTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section].elements[indexPath.row] {
        case .title(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: RealtyTableTitleCell.self), for: indexPath) as! RealtyTableTitleCell
            cell.setup(element: element)
            return cell
        case .item(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: RealtyTableItemCell.self), for: indexPath) as! RealtyTableItemCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension RealtyTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        16.scale
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case .title(let element) = sections[indexPath.section].elements[indexPath.row] else { return }
        
        if !element.isAvailable {
            didTapPaidSectionTrigger.accept(Void())
        }
    }
}

// MARK: Private
private extension RealtyTableView {
    func initialize() {
        register(RealtyTableTitleCell.self, forCellReuseIdentifier: String(describing: RealtyTableTitleCell.self))
        register(RealtyTableItemCell.self, forCellReuseIdentifier: String(describing: RealtyTableItemCell.self))
        
        dataSource = self
        delegate = self
    }
}
