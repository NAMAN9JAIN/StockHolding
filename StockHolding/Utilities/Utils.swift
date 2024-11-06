//
//  Utils.swift
//  StockHolding
//
//  Created by Naman Jain on 04/11/24.
//

import UIKit

extension Double {
    var roundUptoTwoDecimalPlace: String {
        String(format: "%0.2f", self)
    }
}

extension UIView {
    func roundedCorner(radius: CGFloat, corners: UIRectCorner) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
    }
    
    static var identifier: String {
        className
    }

    private static var className: String {
        String(describing: self)
    }

    static func nib() -> UINib {
        UINib(nibName: className, bundle: nil)
    }
}
