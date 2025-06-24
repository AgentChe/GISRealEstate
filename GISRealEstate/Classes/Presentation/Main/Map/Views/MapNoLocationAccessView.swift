//
//  MapNoLocationAccessView.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 24.06.2025.
//

import UIKit

final class MapNoLocationAccessView: UIView {
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var openSettings = makeOpenSettingsButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension MapNoLocationAccessView {
    func initialize() {
        backgroundColor = Appearance.main300
    }
}

// MARK: Make constraints
private extension MapNoLocationAccessView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 218.scale),
            imageView.heightAnchor.constraint(equalToConstant: 231.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 198.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            openSettings.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            openSettings.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            openSettings.heightAnchor.constraint(equalToConstant: 48.scale),
            openSettings.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -34.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MapNoLocationAccessView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Map.NoLocationAccess")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.PublicSans.bold(size: 22.scale))
            .lineHeight(26.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Map.NoLocationAccess.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.PublicSans.regular(size: 16.scale))
            .lineHeight(20.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Map.NoLocationAccess.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeOpenSettingsButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.PublicSans.bold(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Map.NoLocationAccess.OpenSettings".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main100
        view.layer.cornerRadius = 8.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
