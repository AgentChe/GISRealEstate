//
//  SRItemsTableCell.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 30.06.2025.
//

import UIKit

final class SRItemsTableCell: UITableViewCell {
    lazy var titleLabel = makeLabel()
    lazy var valueLabel = makeLabel()
    
    private lazy var titleAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.PublicSans.bold(size: 16.scale))
        .lineHeight(24.scale)
        .textAlignment(.left)
    private lazy var valueAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.PublicSans.regular(size: 16.scale))
        .lineHeight(24.scale)
        .textAlignment(.left)
    
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
extension SRItemsTableCell {
    func setup(element: SRItemsElement) {
        titleLabel.attributedText = element.title.attributed(with: titleAttrs)
        valueLabel.attributedText = element.value.attributed(with: valueAttrs)
    }
}

// MARK: Private
private extension SRItemsTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SRItemsTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6.scale),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SRItemsTableCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
