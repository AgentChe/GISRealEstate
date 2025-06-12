//
//  RealtyTableItemCell.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

import UIKit

final class RealtyTableItemCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var titleLabel = makeLabel()
    lazy var valueLabel = makeLabel()
    
    private lazy var titleAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Quicksand.semiBold(size: 16.scale))
        .textAlignment(.left)
    private lazy var valueAttrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.8))
        .font(Fonts.Quicksand.regular(size: 16.scale))
        .textAlignment(.right)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension RealtyTableItemCell {
    func setup(element: RealtyTableItemElement) {
        titleLabel.attributedText = element.title.attributed(with: titleAttrs)
        valueLabel.attributedText = element.value.attributed(with: valueAttrs)
        
        switch element.corner {
        case .bottom:
            container.layer.cornerRadius = 8.scale
            container.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .none:
            container.layer.cornerRadius = 0
            container.layer.maskedCorners = []
        }
    }
}

// MARK: Private
private extension RealtyTableItemCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        valueLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        valueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}

// MARK: Make constraints
private extension RealtyTableItemCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8.scale),
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            valueLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale),
            valueLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension RealtyTableItemCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.custom219_223_230
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
