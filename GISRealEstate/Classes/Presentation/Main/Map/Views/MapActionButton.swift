//
//  MapActionButton.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 24.06.2025.
//

import UIKit

final class MapActionButton: TapAreaButton {
    lazy var iconView = makeIconView()
    
    private let imageName: String
    
    init(imageName: String) {
        self.imageName = imageName
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension MapActionButton {
    func initialize() {
        backgroundColor = Appearance.main300
        layer.cornerRadius = 28.scale
        layer.masksToBounds = false
        layer.shadowColor = Appearance.main400.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = .zero
        layer.shadowRadius = 4.scale
    }
}

// MARK: Make constraints
private extension MapActionButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension MapActionButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: imageName)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
