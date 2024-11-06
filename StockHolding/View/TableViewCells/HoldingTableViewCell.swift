//
//  HoldingTableViewCell.swift
//  StockHolding
//
//  Created by Naman Jain on 01/11/24.
//

import UIKit

final class HoldingTableViewCell: UITableViewCell {
    enum Constants {
        static let quantityPrefix = "NET QTY:"
        static let ltpPrefix = "LTP:"
        static let PnLPrefix = "P&L:"
    }
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var lastTradedPriceLabel: UILabel!
    @IBOutlet weak var profitLossLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDefaultProperties()
    }
    
    func setup(with data: HoldingUIData) {
        symbolLabel.text = data.companySymbol
        profitLossLabel.textColor = data.isInProfit ? UIColor.green : UIColor.red
        quantityLabel.attributedText = "\(Constants.quantityPrefix) \(data.quantityBought)".getFinalAttributedString(subStringPrefix: Constants.quantityPrefix)
        lastTradedPriceLabel.attributedText = "\(Constants.ltpPrefix) \(data.lastTradedPrice)".getFinalAttributedString(subStringPrefix: Constants.ltpPrefix)
        profitLossLabel.attributedText = "\(Constants.PnLPrefix) \(data.totalProfitOrLoss)".getFinalAttributedString(subStringPrefix: Constants.PnLPrefix)
    }

    private func setupDefaultProperties() {
        selectionStyle = .none
        
        symbolLabel.font = UIFont.boldSystemFont(ofSize: 16)
        symbolLabel.textColor = .black
        quantityLabel.font = UIFont.systemFont(ofSize: 14)
        quantityLabel.textColor = .black
        lastTradedPriceLabel.font = UIFont.systemFont(ofSize: 14)
        lastTradedPriceLabel.textColor = .black
        profitLossLabel.font = UIFont.systemFont(ofSize: 14)
        profitLossLabel.textColor = .green
    }
}

extension String {
    func getRange(of string: String) -> NSRange {
        (self as NSString).range(of: string)
    }

    func getFinalAttributedString(subStringPrefix: String, color: UIColor = .gray, font: UIFont = UIFont.systemFont(ofSize: 10)) -> NSAttributedString {
        let finalAttributedString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        let subStringRange = getRange(of: subStringPrefix)
        
        finalAttributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: color
        ], range: subStringRange)
        
        return finalAttributedString
    }
}
