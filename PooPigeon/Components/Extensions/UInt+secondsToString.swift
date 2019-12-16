//
//  UInt+secondsToString.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 12/17/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import Foundation

extension UInt{

    static func secondsToString(seconds: UInt) -> String {
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.unitsStyle = .abbreviated
        dateComponentsFormatter.allowedUnits = [.day, .hour, .minute]
        if let formattedString = dateComponentsFormatter.string(from: Double(seconds)){
            return formattedString
        }
        return ""
    }
    
}
