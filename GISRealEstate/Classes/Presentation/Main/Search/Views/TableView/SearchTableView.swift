//
//  SearchTableView.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 25.06.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchTableView: UITableView {
    private lazy var elements = [SearchTableElement]()
    
    private lazy var didScrollToBottomTrigger = PublishRelay<Void>()
    private lazy var didSelectTrigger = PublishRelay<SearchTableElement>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SearchTableView {
    func setup(elements: [SearchTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didScrollToBottom: Signal<Void> {
        didScrollToBottomTrigger.asSignal()
    }
    
    var didSelect: Signal<SearchTableElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension SearchTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: SearchTableCell.self), for: indexPath) as! SearchTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension SearchTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard (elements.count - 1) == indexPath.row else { return }
        
        didScrollToBottomTrigger.accept(Void())
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension SearchTableView {
    func initialize() {
        register(SearchTableCell.self, forCellReuseIdentifier: String(describing: SearchTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
