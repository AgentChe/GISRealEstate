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
    lazy var separator = makeSeparator()
    
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
    }
}

// MARK: Make constraints
private extension SettingsLinkButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 19.5.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -19.5.scale)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            separator.heightAnchor.constraint(equalToConstant: 1.scale),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsLinkButton {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.PublicSans.medium(size: 15.scale))
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
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.isHidden = link == .contactUs
        view.backgroundColor = Appearance.custom199_203_209.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
