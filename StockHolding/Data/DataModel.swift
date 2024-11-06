//
//  DataModel.swift
//  StockHolding
//
//  Created by Naman Jain on 01/11/24.
//

import Foundation

struct Holdings: Decodable {
    let data: HoldingsData
}

struct HoldingsData: Decodable {
    let userHolding: [UserHolding]?
}

struct UserHolding: Decodable {
    let symbol: String?
    let quantity: Int?
    let ltp: Double?
    let avgPrice: Double?
    let close: Double?
}
