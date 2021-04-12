//
//  PriceFormatterUtilsTests.swift
//  meli assesmentTests
//
//  Created by Sergio Gelves on 12/04/21.
//

import XCTest
@testable import meli_assesment

class PriceFormaterUtilsMock: PriceFormaterUtils {
    static var currForm: NumberFormatter?
}

class PriceFormatterUtilsTests: XCTestCase {

    func testCurrencyFormatter() throws {
        // WHEN
        let formatter = PriceFormaterUtils.currencyFormatter

        // THEN
        XCTAssertEqual(formatter.locale.identifier, PriceFormaterUtils.localeId)
        XCTAssertEqual(formatter.numberStyle, .currency)
    }

    func testFormatPrice() throws {
        // GIVEN
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "es_CO")
        formatter.numberStyle = .currency
        PriceFormaterUtilsMock.currForm = formatter

        // WHEN
        let formatted = PriceFormaterUtilsMock.formatPrice(fromFloat: 1222.0)

        // THEN
        XCTAssertEqual(formatted, "$ 1.222")
    }

    func testGetDiscountFrom() throws {
        // GIVEN
        let original: Float = 100.0
        let sale: Float = 40.0
        let perctentageExpc = "60%"

        // WHEN
        let perc = PriceFormaterUtils.getDiscountFrom(originialPrice: original, andWithDiscount: sale)

        // THEN
        XCTAssertEqual(perc, perctentageExpc)
    }

    func testGetSegmentedPayment() throws {
        // GIVEN
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "es_CO")
        formatter.numberStyle = .currency
        PriceFormaterUtilsMock.currForm = formatter

        let value: Float = 54000.0
        let months: Int = 36
        let expected = "36x $ 1.500"

        // WHEN
        let segm = PriceFormaterUtilsMock.getSegmentedPayment(for: value, intoMonths: months)

        // THEN
        XCTAssertEqual(segm, expected)
    }
}
