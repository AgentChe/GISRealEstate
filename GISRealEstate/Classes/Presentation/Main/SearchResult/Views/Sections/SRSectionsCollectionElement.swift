//
//  SRSectionsCollectionElement.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 28.06.2025.
//

import Foundation

final class SRSectionsCollectionElement {
    let section: RealtySearchResultSection
    var selected: Bool
    
    init(section: RealtySearchResultSection, selected: Bool) {
        self.section = section
        self.selected = selected
    }
}
