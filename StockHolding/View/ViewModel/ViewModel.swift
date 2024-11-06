//
//  ViewModel.swift
//  StockHolding
//
//  Created by Naman Jain on 01/11/24.
//

import Foundation

protocol ViewModelInput {
    func getHoldingData()
}

protocol ViewModelData {
    var sectionData: [HoldingSectionData] { get }
    var holdingSummaryData: HoldingSummaryData? { get }
}

protocol ViewModelOutput: AnyObject {
    func updateHoldings()
    func updateHoldingsDataFetchFail(message: String)
}

protocol ViewModel {
    var input: ViewModelInput { get }
    var data: ViewModelData { get }
}

final class DefaultViewModel: ViewModel, ViewModelInput, ViewModelData {
    enum Constants {
        static let apiFailMessage = "Something went wrong. Please try again after sometime."
        static let noHoldingsMessage = "No Holdings present. Start investing."
    }
    var input: ViewModelInput { self }
    var data: ViewModelData { self }

    var sectionData: [HoldingSectionData] = []
    var holdingsData: [UserHolding] = []
    var holdingSummaryData: HoldingSummaryData?
    
    private weak var delegate: ViewModelOutput?
    let usecase: Usecase
    init(usecase: Usecase = DefaultUsecase(), delegate: ViewModelOutput) {
        self.delegate = delegate
        self.usecase = usecase
    }
    
    func getHoldingData() {        
        usecase.fetchHoldingsData { [weak self] result in
            switch result {
            case let .success(holdings):
                guard let data = holdings.data.userHolding, !data.isEmpty else {
                    self?.delegate?.updateHoldingsDataFetchFail(message: Constants.apiFailMessage)
                    return
                }
                self?.holdingsData = data
                self?.updateSectionData(using: data)
                self?.delegate?.updateHoldings()
            case let .failure(reason):
                let textToShow: String
                switch reason {
                case .holdingsNotFetched:
                    textToShow = Constants.apiFailMessage
                case .noHoldingsPresent:
                    textToShow = Constants.noHoldingsMessage
                }
                self?.delegate?.updateHoldingsDataFetchFail(message: textToShow)
            }
        }
    }
    
    func updateSectionData(using data: [UserHolding]) {
        var sectionData: [HoldingSectionData] = []
        var holdingsRowData: [RowData] = []
        
        var currentValue: Double = 0
        var totalInvestment: Double = 0
        var totalProfitOrLoss: Double = 0
        var profitOrLossForToday: Double = 0

        data.forEach { holding in
            let lastTradedPrice = holding.ltp ?? 0
            let avgPrice = holding.avgPrice ?? 0
            let quantity = holding.quantity ?? 0
            let closingPrice = holding.close ?? 0
            let quantityForCalculation: Double = Double(quantity)
            let profit = (((lastTradedPrice) - (avgPrice)) * quantityForCalculation)
            
            currentValue += lastTradedPrice * quantityForCalculation
            totalInvestment += avgPrice * quantityForCalculation
            totalProfitOrLoss += currentValue - totalInvestment
            profitOrLossForToday += (closingPrice - lastTradedPrice) * quantityForCalculation
            
            let UIRelatedData = HoldingUIData(companySymbol: holding.symbol ?? "", lastTradedPrice: "₹\(lastTradedPrice.roundUptoTwoDecimalPlace)", quantityBought: quantity, totalProfitOrLoss: "₹\(profit.roundUptoTwoDecimalPlace)", isInProfit: profit > 0)
            holdingsRowData.append(.holding(UIRelatedData))
        }
        sectionData.append(.init(type: .holdings, rows: holdingsRowData))
        
        if data.count > 0 {
            self.holdingSummaryData = .init(data: [
                .init(key: .currentValue, value: currentValue),
                .init(key: .totalInvestment, value: totalInvestment),
                .init(key: .profitLossForToday, value: profitOrLossForToday),
                .init(key: .totalPnL, value: totalProfitOrLoss)
            ])
        }
        
        self.sectionData = sectionData
    }
}
