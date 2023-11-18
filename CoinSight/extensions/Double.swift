//
//  Double.swift
//  CoinSight
//
//  Created by SinaVN on 8/20/1402 AP.
//

import Foundation

extension Double {
    /// converts a Double to currency with 2-6 decimal places
    ///```
    /// Converts 1234.56 to $1,234.56
    /// Converts 0.123456 to $0.123456
    ///```
    private var currencyFormatter6:NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    /// converts a Double to currency as string with 2-6 decimal places
    ///```
    /// Converts 1234.56 to "$1,234.56"
    /// Converts 0.123456 to "$0.123456"
    ///```
    func asCurrencyWith6Decimala () -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    /// converts a Double to String representation
    ///```
    ///
    /// Converts 0.123456 to "$0.12"
    ///```
    func asNumberString()-> String {
        return String(format: "%.2f", self)
    }
    func asPercentString () -> String {
        return asNumberString() + "%"
    }
}
