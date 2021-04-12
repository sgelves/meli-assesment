//
//  ProductPresenterTests.swift
//  meli assesmentTests
//
//  Created by Sergio Gelves on 12/04/21.
//

import XCTest
@testable import meli_assesment

class ProductPresenterTests: XCTestCase {

    func testStaticProperties() throws {
        // GIVEN
        let view = ProductViewMock()
        let product = Product(id: "1",
                              title: "title",
                              thumbnail: "thumb",
                              price: 10,
                              prices: nil,
                              shipping: ShippingMethod(freeShipping: true))
        let presenter = ProductPresenter(view: view, data: product)

        // WHEN
        let url = URL(string: product.thumbnail)

        // THEN
        XCTAssertEqual(presenter.id, product.id)
        XCTAssertEqual(presenter.title, product.title)
        XCTAssertTrue(presenter.imageUrl?.absoluteURL == url?.absoluteURL)
    }

    func testFormattedProperties() throws {
        // GIVEN
        let promPrice = SinglePrice(id: "", type: "not_standard", amount: 100.0, regularAmount: 50.0)
        let standard = SinglePrice(id: "", type: ProductPriceType.standard.rawValue, amount: 100.0, regularAmount: 50.0)

        let view = ProductViewMock()
        let product = Product(id: "1",
                              title: "title",
                              thumbnail: "thumb",
                              price: 10,
                              prices: PricesList(id: "", prices: [standard, promPrice]),
                              shipping: ShippingMethod(freeShipping: true))

        // WHEN
        let presenter = ProductPresenter(view: view,
                                         data: product,
                                         formatter: PriceFormaterMock.self)

        let mockDiscount = PriceFormaterMock
            .verifyGetDiscountFrom(originialPrice: promPrice.regularAmount!, andWithDiscount: promPrice.amount)
        let mockSegment = PriceFormaterMock
            .verifyGetSegmentedPayment(for: promPrice.regularAmount!, intoMonths: ProductPresenter.segmentedMonths)
        let mockPrice = PriceFormaterMock
            .verifyFormatPrice(fromFloat: product.price)

        // THEN
        // Test that my input is being formatted according to my mock
        XCTAssertNotNil(presenter.discount?.contains(mockDiscount))
        XCTAssertNotNil(presenter.segmentedPayments?.contains(mockSegment))
        XCTAssertNotNil(presenter.price == mockPrice)
    }
}
