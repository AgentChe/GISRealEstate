//
//  RealtyTableTitleCell.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

import UIKit

final class RealtyTableTitleCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var label = makeLabel()
    lazy var lockIconView = makeLockIconView()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Quicksand.bold(size: 21.scale))
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
extension RealtyTableTitleCell {
    func setup(element: RealtyTableTitleElement) {
        label.attributedText = element.title.attributed(with: attrs)
        lockIconView.isHidden = element.isAvailable
        
        switch element.corner {
        case .all:
            container.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .top:
            container.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
}

// MARK: Private
private extension RealtyTableTitleCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension RealtyTableTitleCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -48.scale),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            lockIconView.widthAnchor.constraint(equalToConstant: 24.scale),
            lockIconView.heightAnchor.constraint(equalToConstant: 24.scale),
            lockIconView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            lockIconView.centerYAnchor.constraint(equalTo: label.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension RealtyTableTitleCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 8.scale
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
    
    func makeLockIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Realty.Lock")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
