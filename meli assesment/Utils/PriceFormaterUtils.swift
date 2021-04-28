//
//  PriceFormaterUtils.swift
//  meli assesment
//
//  Created by Sergio Gelves on 12/04/21.
//

import Foundation

protocol PriceFormatterProtocol {
    static var currencyFormatter: NumberFormatter { get }

    static func getDiscountFrom(originialPrice original: Float, andWithDiscount discount: Float) -> String
    static func getSegmentedPayment(for price: Float, intoMonths months: Int) -> String?
    static func formatPrice(fromFloat price: Float) -> String?
}

class PriceFormaterUtils: PriceFormatterProtocol {

    static var localeId =  "es_CO"

    private static func gertCurrencyFormt() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: localeId)
        formatter.numberStyle = .currency
        return formatter
    }

    static let currencyFormatter: NumberFormatter = gertCurrencyFormt()

    static func formatPrice(fromFloat price: Float) -> String? {
        return currencyFormatter.string(from: NSNumber(value: price))
    }

    static func getDiscountFrom(originialPrice original: Float, andWithDiscount discount: Float) -> String {
        let percentage = 100 - Int((discount/original) * 100)
        return "\(percentage)%"
    }

    static func getSegmentedPayment(for price: Float, intoMonths months: Int) -> String? {
        let segmentedPrice = round((price/Float(months)) * 100) / 100.0
        if let formattedPrice = formatPrice(fromFloat: segmentedPrice) {
            return "\(months)x \(formattedPrice)"
        }
        return nil
    }
}
