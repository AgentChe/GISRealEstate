//
//  RealtyTableElement.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 11.06.2025.
//

struct RealtyTableSection {
    let elements: [RealtyTableElement]
}

enum RealtyTableElement {
    case title(RealtyTableTitleElement)
    case item(RealtyTableItemElement)
}

struct RealtyTableTitleElement {
    enum Corner {
        case top, all
    }
    
    let title: String
    let isAvailable: Bool
    let corner: Corner
}

struct RealtyTableItemElement {
    enum Corner {
        case bottom, none
    }
    
    let title: String
    let value: String
    let corner: Corner
}
