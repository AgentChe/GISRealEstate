//
//  MapSearchField.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class MapSearchField: UIView {
    lazy var iconView = makeIconView()
    lazy var textField = makeTextField()
    
    private lazy var didTapSearchTrigger = PublishRelay<Void>()
    private lazy var text = BehaviorRelay(value: "")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MapSearchField {
    func setup(text: String?) {
        textField.text = text
        
        textEditing()
    }
    
    var didTapSearch: Signal<Void> {
        didTapSearchTrigger.asSignal()
    }
    
    var changedText: Signal<String> {
        text.asSignal(onErrorSignalWith: .never())
    }
}

// MARK: UITextFieldDelegate
extension MapSearchField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        didTapSearchTrigger.accept(Void())
        
        return true
    }
}

// MARK: Private
private extension MapSearchField {
    func initialize() {
        backgroundColor = Appearance.mono100
        layer.cornerRadius = 10.scale
        layer.masksToBounds = true
    }
    
    @objc
    func textEditing() {
        text.accept(textField.text ?? "")
    }
}

// MARK: Make constraints
private extension MapSearchField {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48.scale),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension MapSearchField {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Map.Search")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextField() -> PaddingTextField {
        let attrs = TextAttributes()
            .textColor(Appearance.custom60_60_67)
            .font(Fonts.Quicksand.regular(size: 17.scale))
            .lineHeight(22.scale)
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.custom60_60_67.withAlphaComponent(0.6))
            .font(Fonts.Quicksand.regular(size: 17.scale))
            .lineHeight(22.scale)
        
        let view = PaddingTextField()
        view.backgroundColor = UIColor.clear
        view.delegate = self
        view.returnKeyType = .search
        view.defaultTextAttributes = attrs.dictionary
        view.attributedPlaceholder = "Map.Search".localized.attributed(with: placeholderAttrs)
        view.textPadding = UIEdgeInsets(vertical: 13.scale)
        view.addTarget(self, action: #selector(textEditing), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
