//
//  SRItemsTableView.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 30.06.2025.
//

import UIKit

final class SRItemsTableView: UITableView {
    private lazy var elements = [SRItemsElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SRItemsTableView {
    func setup(elements: [SRItemsElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension SRItemsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: SRItemsTableCell.self), for: indexPath) as! SRItemsTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension SRItemsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Private
private extension SRItemsTableView {
    func initialize() {
        register(SRItemsTableCell.self, forCellReuseIdentifier: String(describing: SRItemsTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
