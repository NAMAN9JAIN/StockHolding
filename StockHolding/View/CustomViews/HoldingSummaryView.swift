//
//  HoldingSummaryView.swift
//  StockHolding
//
//  Created by Naman Jain on 04/11/24.
//

import UIKit

final class HoldingSummaryView: UIView {
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var otherDataPointsView: HoldingSummaryExpandedPointsView = {
        let view = HoldingSummaryExpandedPointsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var totalProfitLossView: HoldingSummaryDataView = {
        let view = HoldingSummaryDataView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        roundedCorner(radius: 20, corners: UIRectCorner.topLeft.union(.topRight))
        setupConstraints()
        
        otherDataPointsView.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(expandOrCollpaseView))
        totalProfitLossView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }

    func setup(with summary: HoldingSummaryData) {
        backgroundColor = .blue.withAlphaComponent(0.2)
        var summaryData = summary.data
        let totalProfitLossData = summaryData.removeLast()
        otherDataPointsView.setup(with: summaryData)
        totalProfitLossView.setup(keyData: totalProfitLossData.key.title, valueData: totalProfitLossData.value, isForTotalProfitLoss: true)
    }

    @objc
    private func expandOrCollpaseView() {
        UIView.transition(with: stackView, duration: 0.1, options: .curveEaseIn, animations: {
            self.otherDataPointsView.isHidden.toggle()
        })
    }
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(otherDataPointsView)
        stackView.addArrangedSubview(totalProfitLossView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32)
        ])
    }
}

