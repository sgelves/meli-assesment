//
//  PriceFormaterMock.swift
//  meli assesmentTests
//
//  Created by Sergio Gelves on 12/04/21.
//

@testable import meli_assesment
import Foundation

class PriceFormaterStub: PriceFormatterProtocol {
    static let currencyFormatter: NumberFormatter = PriceFormaterUtils.currencyFormatter

    static func verifyGetDiscountFrom(originialPrice original: Float, andWithDiscount discount: Float) -> String {
        return "Éxito \(original) \(discount)"
    }

    static func verifyGetSegmentedPayment(for price: Float, intoMonths months: Int) -> String {
        return "Éxito \(price) \(months)"
    }

    static func verifyFormatPrice(fromFloat price: Float) -> String {
        return "Éxito \(price)"
    }

    static func getDiscountFrom(originialPrice original: Float, andWithDiscount discount: Float) -> String {
        return "Éxito \(original) \(discount)"
    }

    static func getSegmentedPayment(for price: Float, intoMonths months: Int) -> String? {
        return "Éxito \(price) \(months)"
    }

    static func formatPrice(fromFloat price: Float) -> String? {
        return "Éxito \(price)"
    }
}
