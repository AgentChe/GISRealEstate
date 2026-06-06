//
//  GlobalDefinitions.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

final class GlobalDefinitions {
    static let domain = "https://realty.thinkaboutapps.com"
    static let apiKey = "ldgfhnwluefoqwef"
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "FCOhobiDpN3gdPo4"
    
    static let termsOfServiceUrl = URL(string: "https://thinkaboutapps.com/terms")!
    static let privacyPolicyUrl = URL(string: "https://thinkaboutapps.com/policy")!
    static let contactUsUrl = URL(string: "https://thinkaboutapps.com/contact")!
    
    enum Paygate {
        static let yearly = "com.gisrealestate.yearly"
        static let monthly = "com.gisrealestate.monthly.nottrial"
    }
}
