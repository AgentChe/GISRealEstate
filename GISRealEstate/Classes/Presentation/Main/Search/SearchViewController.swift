//
//  SearchViewController.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 25.06.2025.
//

import UIKit
import RxSwift

final class SearchViewController: UIViewController {
    private lazy var mainView = SearchView()
    
    private lazy var viewModel = SearchViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.rx.willBeginDragging
            .bind(to: mainView.rx.hideKeyboardObserver)
            .disposed(by: disposeBag)
        
        let output = viewModel.configure(input: SearchViewModel.Input(
            didSelectProposedTab: mainView.proposedPickerView.didSelect,
            didScrollToBottom: mainView.tableView.didScrollToBottom,
            didSelect: mainView.tableView.didSelect,
            didSearch: mainView.searchField.didTapSearch
        ))
        
        output.proposedTab
            .drive(Binder(mainView) { base, tab in
                base.proposedPickerView.update(tab: tab)
                base.emptyView.update(proposedTab: tab)
            })
            .disposed(by: disposeBag)
        
        output.firstPageActivity
            .drive(Binder(mainView.centerPreloader) { base, activity in
                activity ? base.startAnimating() : base.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.paginationActivity
            .drive(Binder(mainView) { base, activity in
                base.tableView.contentInset.bottom = activity ? 48.scale : 18.scale
                activity ? base.tableBottomPreloader.startAnimating() : base.tableBottomPreloader.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.emptyHidden
            .drive(mainView.emptyView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        mainView.searchField.textField.becomeFirstResponder()
    }
}

// MARK: Public
extension SearchViewController {
    static func make() -> NavigationController {
        let vc = SearchViewController()
        vc.navigationItem.backButtonTitle = " "
        
        let nc = NavigationController(rootViewController: vc)
        nc.setNavigationBarHidden(true, animated: false)
        return nc
    }
}

// MARK: Private
private extension SearchViewController {
    func action(_ action: SearchViewModel.Action) {
        switch action {
        case .searchAddress(let address):
            print(address) // TODO
        case .searchCoordinate(let coordinate):
            print(coordinate) // TODO
        }
    }
}
