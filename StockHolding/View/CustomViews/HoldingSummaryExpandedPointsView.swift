//
//  HoldingSummaryExpandedPointsView.swift
//  StockHolding
//
//  Created by Naman Jain on 04/11/24.
//

import UIKit

final class HoldingSummaryExpandedPointsView: UIView {
    private var currentValueView: HoldingSummaryDataView = {
        let view = HoldingSummaryDataView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var totalInvestmentView: HoldingSummaryDataView = {
        let view = HoldingSummaryDataView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var profitLossForTodayView: HoldingSummaryDataView = {
        let view = HoldingSummaryDataView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }
    
    func setup(with data: [HoldingSummaryData.Data]) {
        for points in data {
            switch points.key {
            case .currentValue:
                currentValueView.setup(keyData: points.key.title, valueData: points.value)
            case .totalInvestment:
                totalInvestmentView.setup(keyData: points.key.title, valueData: points.value)
            case .profitLossForToday:
                profitLossForTodayView.setup(keyData: points.key.title, valueData: points.value)
            default: break
            }
        }
    }
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
    
        addSubview(currentValueView)
        addSubview(totalInvestmentView)
        addSubview(profitLossForTodayView)
        
        NSLayoutConstraint.activate([
            currentValueView.leadingAnchor.constraint(equalTo: leadingAnchor),
            currentValueView.topAnchor.constraint(equalTo: topAnchor),
            currentValueView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            totalInvestmentView.topAnchor.constraint(equalTo: currentValueView.bottomAnchor),
            totalInvestmentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            totalInvestmentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            profitLossForTodayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profitLossForTodayView.topAnchor.constraint(equalTo: totalInvestmentView.bottomAnchor),
            profitLossForTodayView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profitLossForTodayView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
