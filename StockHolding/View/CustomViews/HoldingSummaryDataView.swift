//
//  HoldingSummaryDataView.swift
//  StockHolding
//
//  Created by Naman Jain on 04/11/24.
//

import UIKit

final class HoldingSummaryDataView: UIView {
    private var key: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var value: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var keyTopConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }
    
    func setup(keyData: String, valueData: Double, isForTotalProfitLoss: Bool = false) {
        key.text = keyData
        value.text = "₹ \(valueData.roundUptoTwoDecimalPlace)"
        value.textColor = valueData < 0 ? UIColor.red : UIColor.black
        keyTopConstraint.constant = isForTotalProfitLoss ? 12 : 8

        layoutIfNeeded()
    }
    
    private func setupDefaultProperties() {
        key.font = UIFont.systemFont(ofSize: 14)
        key.textColor = .gray
        value.font = UIFont.systemFont(ofSize: 14)
    }
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(key)
        addSubview(value)
        
        keyTopConstraint = key.topAnchor.constraint(equalTo: topAnchor)
        
        NSLayoutConstraint.activate([
            keyTopConstraint,
            key.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            key.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            
            value.leadingAnchor.constraint(greaterThanOrEqualTo: key.trailingAnchor, constant: 12),
            value.centerYAnchor.constraint(equalTo: key.centerYAnchor),
            value.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
    }
}
