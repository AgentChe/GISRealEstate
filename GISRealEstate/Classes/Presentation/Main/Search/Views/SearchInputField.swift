//
//  SearchInputField.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 25.06.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchInputField: UIView {
    lazy var iconView = makeIconView()
    lazy var textField = makeTextField()
    
    private lazy var didTapSearchTrigger = PublishRelay<String>()
    
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
extension SearchInputField {
    func setup(text: String?) {
        textField.text = text
    }
    
    var didTapSearch: Signal<String> {
        didTapSearchTrigger.asSignal()
    }
}

// MARK: UITextFieldDelegate
extension SearchInputField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = (textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return false }
        
        textField.resignFirstResponder()
        
        didTapSearchTrigger.accept(text)
        
        return true
    }
}

// MARK: Private
private extension SearchInputField {
    func initialize() {
        backgroundColor = Appearance.custom239_241_246
        layer.cornerRadius = 24.scale
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension SearchInputField {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50.scale),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SearchInputField {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Search.Search")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextField() -> PaddingTextField {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.PublicSans.regular(size: 16.scale))
            .lineHeight(20.scale)
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.6))
            .font(Fonts.PublicSans.regular(size: 16.scale))
            .lineHeight(20.scale)
        
        let view = PaddingTextField()
        view.backgroundColor = UIColor.clear
        view.delegate = self
        view.returnKeyType = .search
        view.defaultTextAttributes = attrs.dictionary
        view.attributedPlaceholder = "Search.PlaceholderText".localized.attributed(with: placeholderAttrs)
        view.textPadding = UIEdgeInsets(vertical: 14.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
