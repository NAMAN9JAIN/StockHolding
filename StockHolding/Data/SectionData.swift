//
//  SectionData.swift
//  StockHolding
//
//  Created by Naman Jain on 02/11/24.
//

import Foundation

enum SectionType {
    case holdings
}

enum RowData {
    case holding(HoldingUIData)
}

struct HoldingUIData {
    let companySymbol: String
    let lastTradedPrice: String
    let quantityBought: Int
    let totalProfitOrLoss: String
    let isInProfit: Bool
}

struct HoldingSummaryData {
    let data: [Data]
    
    struct Data {
        let key: SummaryDataPointType
        let value: Double
        
        enum SummaryDataPointType {
            case currentValue
            case totalInvestment
            case profitLossForToday
            case totalPnL
            
            var title: String {
                switch self {
                case .currentValue:
                    return "Current Value"
                case .totalInvestment:
                    return "Total Investment"
                case .profitLossForToday:
                    return "Today's Profit & Loss"
                case .totalPnL:
                    return "Profit & Loss"
                }
            }
        }
    }
}

struct HoldingSectionData {
    let type: SectionType
    let rows: [RowData]
}
