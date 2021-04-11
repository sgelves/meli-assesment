//
//  ProductListPresenterTests.swift
//  meli assesmentTests
//
//  Created by Sergio Gelves on 10/04/21.
//

import XCTest
@testable import meli_assesment

class ProductListPresenterTests: XCTestCase {

    func testSearchProducts() throws {
        // GIVEN
        let view = ProductListViewMock()

        let products: [Product] = []

        let responseTotal = 10

        ProductsServicesMock.producListResultAmount = responseTotal
        let presenter = ProductListPresenter(view: view,
                                             limit: 10,
                                             query: "test",
                                             products: products,
                                             service: ProductsServicesMock.self)

        // WHEN
        let expc = expectation(description: "data should be updated")

        presenter.searchProducts()

        // THEN
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let state = view.currentState {
                XCTAssertEqual(presenter.products.count, products.count + responseTotal)
                XCTAssertEqual(state, .withData)
                XCTAssertEqual(view.reloadViewCalled, true)
                expc.fulfill()
            } else {
                XCTFail("Data is not being updates")
            }
        }

        wait(for: [expc], timeout: 1)
    }


    func testSearchEmptyProductsResult() throws {
        // GIVEN
        let view = ProductListViewMock()

        var products: [Product] = []

        let responseTotal = 0

        ProductsServicesMock.producListResultAmount = responseTotal
        var presenter = ProductListPresenter(view: view,
                                             limit: 10,
                                             query: "test",
                                             products: products,
                                             service: ProductsServicesMock.self)

        // WHEN
        var expc = expectation(description: "data should be empty")

        presenter.searchProducts()

        // THEN
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let state = view.currentState {
                XCTAssertEqual(presenter.products.count, 0)
                XCTAssertEqual(state, .empty)
                expc.fulfill()
            } else {
                XCTFail("Data is not empty")
            }
        }

        wait(for: [expc], timeout: 1)

        // AND
        products = ProductsServicesMock.getMockedResult(10)

        presenter = ProductListPresenter(view: view,
                                         limit: 10,
                                         query: "test",
                                         products: products,
                                         service: ProductsServicesMock.self)
        // WHEN
        expc = expectation(description: "data should preserve its state")

        presenter.searchProducts()

        // THEN
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let state = view.currentState {
                XCTAssertEqual(presenter.products.count, products.count)
                XCTAssertEqual(state, .noData)
                expc.fulfill()
            } else {
                XCTFail("Data has been changed")
            }
        }

        wait(for: [expc], timeout: 1)
    }

    func testSearchErrorProductsResult() throws {
        // GIVEN
        let view = ProductListViewMock()

        var products: [Product] = []

        ProductsServicesMock.producListResultAmount = -1 // error
        var presenter = ProductListPresenter(view: view,
                                             limit: 10,
                                             query: "test",
                                             products: products,
                                             service: ProductsServicesMock.self)

        // WHEN
        var expc = expectation(description: "error should leave an empty state")

        presenter.searchProducts()

        // THEN
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let state = view.currentState {
                XCTAssertEqual(presenter.products.count, 0)
                XCTAssertEqual(state, .empty)
                expc.fulfill()
            } else {
                XCTFail("Data is not empty")
            }
        }

        wait(for: [expc], timeout: 1)

        // AND
        products = ProductsServicesMock.getMockedResult(10)

        presenter = ProductListPresenter(view: view,
                                         limit: 10,
                                         query: "test",
                                         products: products,
                                         service: ProductsServicesMock.self)
        // WHEN
        expc = expectation(description: "error should cause a no data state, bc there were already data")

        presenter.searchProducts()

        // THEN
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let state = view.currentState {
                XCTAssertEqual(presenter.products.count, products.count)
                XCTAssertEqual(state, .noData)
                expc.fulfill()
            } else {
                XCTFail("Data has been changed")
            }
        }

        wait(for: [expc], timeout: 1)
    }

    func testSetQuery() throws {
        // GIVEN
        let query = "test"

        let view = ProductListViewMock()

        let products: [Product] = ProductsServicesMock.getMockedResult(10)

        let presenter = ProductListPresenter(view: view,
                                             limit: 10,
                                             query: query,
                                             products: products,
                                             service: ProductsServicesMock.self)

        // WHEN
        presenter.setQuery("another test")

        // THEN
        XCTAssertNotEqual(presenter.query, query)
        XCTAssertEqual(presenter.products.count, 0)
    }
}
