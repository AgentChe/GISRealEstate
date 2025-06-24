//
//  SettingsView.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

import UIKit

final class SettingsView: UIView {
    lazy var termsOfUseButton = makeLinkButton(link: .termsOfUse)
    lazy var privacyPolicyButton = makeLinkButton(link: .privacyPolicy)
    lazy var contactUsButton = makeLinkButton(link: .contactUs)
    lazy var imageView = makeImageView()
    
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
private extension SettingsView {
    func initialize() {
        backgroundColor = Appearance.main300
    }
}

// MARK: Make constraints
private extension SettingsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            termsOfUseButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            termsOfUseButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            termsOfUseButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            privacyPolicyButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            privacyPolicyButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            privacyPolicyButton.topAnchor.constraint(equalTo: termsOfUseButton.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contactUsButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            contactUsButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            contactUsButton.topAnchor.constraint(equalTo: privacyPolicyButton.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 408.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsView {
    func makeLinkButton(link: SettingsLinkButton.Link) -> SettingsLinkButton {
        let view = SettingsLinkButton(link: link)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Settings.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
