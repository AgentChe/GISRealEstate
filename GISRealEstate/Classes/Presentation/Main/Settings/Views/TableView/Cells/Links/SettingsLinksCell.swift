//
//  SettingsLinksCell.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 12.06.2025.
//

import UIKit

final class SettingsLinksCell: UITableViewCell {
    var didTapLink: ((SettingsLinkButton.Link) -> Void)?
    
    lazy var container = makeContainer()
    lazy var contactUsButton = makeLinkButton(link: .contactUs)
    lazy var termsOfUseButton = makeLinkButton(link: .termsOfUse)
    lazy var privacyPolicyButton = makeLinkButton(link: .privacyPolicy)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension SettingsLinksCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func linkButtonTapped(sender: UIButton) {
        guard let linkButton = sender as? SettingsLinkButton else { return }
        
        didTapLink?(linkButton.link)
    }
}

// MARK: Make constraints
private extension SettingsLinksCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contactUsButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            contactUsButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            contactUsButton.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            termsOfUseButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            termsOfUseButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            termsOfUseButton.topAnchor.constraint(equalTo: contactUsButton.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            privacyPolicyButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            privacyPolicyButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            privacyPolicyButton.topAnchor.constraint(equalTo: termsOfUseButton.bottomAnchor),
            privacyPolicyButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsLinksCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 8.scale
        view.backgroundColor = Appearance.main100
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLinkButton(link: SettingsLinkButton.Link) -> SettingsLinkButton {
        let view = SettingsLinkButton(link: link)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(linkButtonTapped(sender:)), for: .touchUpInside)
        container.addSubview(view)
        return view
    }
}
