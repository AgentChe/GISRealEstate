//
//  SearchResultViewController.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 27.06.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchResultViewController: UIViewController {
    private lazy var mainView = SearchResultView()
    
    private let viewModel: SearchResultViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didTapMarkedTrigger = PublishRelay<FavoriteId?>()
    
    private init(address: String) {
        viewModel = SearchResultViewModel(address: address)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    private init(coordinate: Coordinate) {
        viewModel = SearchResultViewModel(coordinate: coordinate)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            self?.open(error: error) ?? .empty()
        }
        
        let output = viewModel.configure(input: SearchResultViewModel.Input(
            didTapClose: mainView.headerView.didTapClose,
            didTapMark: didTapMarkedTrigger.asSignal(),
            didSelectSection: mainView.sectionsView.didSelect
        ))
        
        let favorite = output.favorite
        
        mainView.headerView.favoriteButton.rx.tap
            .withLatestFrom(favorite)
            .bind(to: didTapMarkedTrigger)
            .disposed(by: disposeBag)
        
        favorite
            .drive(Binder(mainView.headerView) { base, favoriteId in
                base.setup(favorite: favoriteId != nil)
            })
            .disposed(by: disposeBag)
        
        
        output.title
            .drive(Binder(mainView.headerView) { base, title in
                base.setup(title: title)
            })
            .disposed(by: disposeBag)
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(mainView.preloader) { base, activity in
                activity ? base.startAnimating() : base.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.emptyHidden
            .drive(mainView.emptyView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.sections
            .drive(Binder(mainView.sectionsView) { base, sections in
                base.setup(elements: sections)
            })
            .disposed(by: disposeBag)
        
        output.items
            .drive(Binder(mainView.itemsView) { base, items in
                base.setup(elements: items)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension SearchResultViewController {
    static func make(address: String) -> SearchResultViewController {
        let vc = SearchResultViewController(address: address)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
    
    static func make(coordinate: Coordinate) -> SearchResultViewController {
        let vc = SearchResultViewController(coordinate: coordinate)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension SearchResultViewController {
    func action(_ action: SearchResultViewModel.Action) {
        switch action {
        case .close:
            if let nc = navigationController {
                nc.dismiss(animated: true)
            } else {
                dismiss(animated: true)
            }
        case .openPaygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        }
    }
    
    func open(error: Error) -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make(error: error) {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}
