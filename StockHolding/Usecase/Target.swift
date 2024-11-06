//
//  Target.swift
//  StockHolding
//
//  Created by Naman Jain on 01/11/24.
//

import Foundation

enum DefaultTarget: Target {
    case holding
}

extension DefaultTarget {
    var baseUrl: String {
        "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io"
    }
    
    var endpoint: String {
        ""
    }
    
    var method: HTTPMethod {
        .get
    }
}
