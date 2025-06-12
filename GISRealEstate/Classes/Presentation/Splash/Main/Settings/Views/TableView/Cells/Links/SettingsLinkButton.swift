//
//  SettingsLinkButton.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 12.06.2025.
//

import UIKit

final class SettingsLinkButton: UIButton {
    enum Link {
        case contactUs
        case termsOfUse
        case privacyPolicy
    }
    
    let link: Link
    
    lazy var label = makeLabel()
    lazy var arrowView = makeArrowView()
    
    init(link: Link) {
        self.link = link
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension SettingsLinkButton {
    func initialize() {
        backgroundColor = UIColor.clear
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension SettingsLinkButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 21.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -21.scale)
        ])
        
        NSLayoutConstraint.activate([
            arrowView.widthAnchor.constraint(equalToConstant: 20.scale),
            arrowView.heightAnchor.constraint(equalToConstant: 20.scale),
            arrowView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsLinkButton {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Quicksand.medium(size: 15.scale))
            .lineHeight(18.scale)
            .textAlignment(.left)
        
        let string: String = {
            switch link {
            case .contactUs:
                return "Settings.Links.ContactUs".localized
            case .termsOfUse:
                return "Settings.Links.TermsOfUse".localized
            case .privacyPolicy:
                return "Settings.Links.PrivacyPolicy".localized
            }
        }()
        
        let view = UILabel()
        view.attributedText = string.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeArrowView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Settings.Arrow")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
