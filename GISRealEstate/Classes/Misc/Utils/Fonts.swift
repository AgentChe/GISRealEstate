//
//  Fonts.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

// TODO
struct Fonts {
    // MARK: Quicksand
    struct Quicksand {
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "Quicksand-SemiBold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Quicksand-Regular", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "Quicksand-Medium", size: size)!
        }
        
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "Quicksand-Bold", size: size)!
        }
    }
}
