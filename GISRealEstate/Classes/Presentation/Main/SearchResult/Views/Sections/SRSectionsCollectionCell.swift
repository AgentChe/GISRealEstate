//
//  SRSectionsCollectionCell.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 28.06.2025.
//

import UIKit
import Kingfisher

final class SRSectionsCollectionCell: UICollectionViewCell {
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    
    private static let selectedAttrs = TextAttributes()
        .textColor(Appearance.main200)
        .font(Fonts.PublicSans.bold(size: 16.scale))
        .lineHeight(24.scale)
        .textAlignment(.left)
    private static let deselectedAttrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.5))
        .font(Fonts.PublicSans.bold(size: 16.scale))
        .lineHeight(24.scale)
        .textAlignment(.left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconView.kf.cancelDownloadTask()
        iconView.image = nil
    }
}

// MARK: Public
extension SRSectionsCollectionCell {
    static func height(for element: SRSectionsCollectionElement) -> CGFloat {
        let string = element.section.title.attributed(with: Self.selectedAttrs)
        return string.size().width + 60.scale
    }
    
    func setup(element: SRSectionsCollectionElement) {
        // TODO: цвет иконки в зависимости от значения selected
        iconView.kf.setImage(with: element.section.icon)
        print("url: \(element.section.icon)") // TODO
        
        let attrs = element.selected ? Self.selectedAttrs : Self.deselectedAttrs
        label.attributedText = element.section.title.attributed(with: attrs)
        
        contentView.backgroundColor = element.selected ? Appearance.custom216_238_217 : Appearance.custom239_241_246
    }
}

// MARK: Private
private extension SRSectionsCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.layer.cornerRadius = 22.scale
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension SRSectionsCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44.scale),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SRSectionsCollectionCell {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
