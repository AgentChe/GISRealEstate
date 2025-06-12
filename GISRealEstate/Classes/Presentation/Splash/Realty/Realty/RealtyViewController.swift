//
//  RealtyViewController.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

import UIKit
import RxSwift

final class RealtyViewController: UIViewController {
    private lazy var mainView = RealtyView()
    
    private let viewModel: RealtyViewModel
    
    private init(coordinate: Coordinate) {
        viewModel = RealtyViewModel(coordinate: coordinate)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    private init(address: String) {
        viewModel = RealtyViewModel(address: address)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: RealtyViewModel.Input(
            didTapPaidSection: mainView.tableView.didTapPaidSection
        ))
        
        output.sections
            .drive(Binder(mainView.tableView) { base, sections in
                base.setup(sections: sections)
            })
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(mainView) { base, activity in
                base.tableView.isHidden = activity
                activity ? base.preloader.startAnimating() : base.preloader.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension RealtyViewController {
    static func make(coordinate: Coordinate) -> RealtyViewController {
        let vc = RealtyViewController(coordinate: coordinate)
        vc.navigationItem.title = String(format: "%.4f, %.4f", coordinate.lat, coordinate.lon)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
    
    static func make(address: String) -> RealtyViewController {
        let vc = RealtyViewController(address: address)
        vc.navigationItem.title = address
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension RealtyViewController {
    func action(_ action: RealtyViewModel.Action) {
        switch action {
        case .openPaygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        }
    }
}
