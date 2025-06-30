//
//  SRSectionsCollectionView.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 28.06.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SRSectionsCollectionView: UICollectionView {
    private lazy var elements = [SRSectionsCollectionElement]()
    
    private lazy var didSelectTrigger = PublishRelay<SRSectionsCollectionElement>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SRSectionsCollectionView {
    func setup(elements: [SRSectionsCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<SRSectionsCollectionElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension SRSectionsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: SRSectionsCollectionCell.self), for: indexPath) as! SRSectionsCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension SRSectionsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: SRSectionsCollectionCell.height(for: elements[indexPath.row]), height: bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let needPayment = elements[indexPath.row].section.paid ? !SessionManager().hasActiveSubscriptions() : false
        if !needPayment {
            elements.enumerated().forEach { index, element in
                element.selected = index == indexPath.row
            }
            
            reloadData()
        }
        
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension SRSectionsCollectionView {
    func initialize() {
        register(SRSectionsCollectionCell.self, forCellWithReuseIdentifier: String(describing: SRSectionsCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
