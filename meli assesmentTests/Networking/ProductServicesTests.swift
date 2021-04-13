//
//  ProductServicesTests.swift
//  meli assesmentTests
//
//  Created by Sergio Gelves on 9/04/21.
//

import XCTest
import Mocker
import Alamofire

@testable import meli_assesment

extension Networking {}

class ProductServicesTests: XCTestCase {

    private func readLocalFile(forName name: String) throws -> Data? {

        if let bundleUrl = Bundle(for: type(of: self)).url(forResource: name, withExtension: "json") {
            let data = try? Data(contentsOf: bundleUrl, options: .mappedIfSafe)
            return data
        }

        return nil
    }

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])

        Networking.sessionManager = Session(configuration: configuration)
    }

    override func tearDownWithError() throws {
        Networking.sessionManager = Session()
    }

    func testGetSingleProducts() throws {
        // Given
        let productId = "MLB1698042476"
        let productPath = String(format: ProductsServices.Paths.singleProduct.rawValue, productId)
        let apiEndpoint = URL(string: "\(Networking.Domain.develop.rawValue)\(productPath)")!
        let jsonData = try readLocalFile(forName: "ProductResponse")

        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 200, data: [.get: jsonData!])
        mock.register()

        let productJson = (try? JSONDecoder().decode(Product.self, from: jsonData!))
            ?? Product(id: "", title: "", thumbnail: "", price: 0.0, shipping: ShippingMethod(freeShipping: true))

        let requestExpectation = expectation(description: "Request should complete")
        let requestErrorExpectation = expectation(description: "Request should fail with error")
        // When
        ProductsServices.getSingleProducts(byId: productId) { result in
            // Then
            switch result {
            case let .success(product):
                XCTAssertTrue(product.id == productJson.id)
                XCTAssertTrue(product.title == productJson.title)
                XCTAssertTrue(product.price == productJson.price)
                XCTAssertTrue(product.thumbnail == productJson.thumbnail)
                requestExpectation.fulfill()
            case .failure:
                XCTFail("Request should succeed")
            }
        }

        // When
        ProductsServices.getSingleProducts(byId: "") { result in
            // Then
            switch result {
            case .success:
                XCTFail("Request should fail")
            case let .failure(err):
                XCTAssertEqual(ApiError.invalidParameters, err)
                requestErrorExpectation.fulfill()
            }
        }

        wait(for: [requestExpectation, requestErrorExpectation], timeout: 10.0)
    }

    func testGetProductDescription() throws {
        // Given
        let productId = "MLB1698042476"
        let productPath = String(format: ProductsServices.Paths.productDescription.rawValue, productId)
        let apiEndpoint = URL(string: "\(Networking.Domain.develop.rawValue)\(productPath)")!
        let jsonData = try readLocalFile(forName: "ProductDescriptionResponse")

        let mock = Mock(url: apiEndpoint, ignoreQuery: true,  dataType: .json, statusCode: 200, data: [.get: jsonData!])
        mock.register()

        let productJson = (try? JSONDecoder().decode(ProductDescription.self, from: jsonData!))
            ?? ProductDescription(plainText: "")

        let requestExpectation = expectation(description: "Request should complete")
        let requestErrorExpectation = expectation(description: "Request should fail with error")
        // When
        ProductsServices.getProductDescription(byId: productId) { result in
            // Then
            switch result {
            case let .success(description):
                XCTAssertTrue(description.plainText == productJson.plainText)
                requestExpectation.fulfill()
            case .failure:
                XCTFail("Request should succeed")
            }
        }

        // When
        ProductsServices.getProductDescription(byId: "") { result in
            // Then
            switch result {
            case .success:
                XCTFail("Request should fail")
            case let .failure(err):
                XCTAssertEqual(ApiError.invalidParameters, err)
                requestErrorExpectation.fulfill()
            }
        }

        wait(for: [requestExpectation, requestErrorExpectation], timeout: 10.0)
    }

    func testGetProductList() throws {
        // Given
        let query = "example"
        let offset = 0
        let limit = 10

        let path = ProductsServices.Paths.productsList.rawValue
        let apiEndpoint = URL(string: "\(Networking.Domain.develop.rawValue)\(path)")!
        let jsonData = try readLocalFile(forName: "ProductQueryResponse")

        let mock = Mock(url: apiEndpoint, ignoreQuery: true,  dataType: .json, statusCode: 200, data: [.get: jsonData!])

        mock.register()

        let requestExpectation = expectation(description: "Request should finish")
        let requestQueryErrorExpectation = expectation(description: "Request should fail for query param")
        let requestLimitErrorExpectation = expectation(description: "Request should fail for limit param")
        let requestOffsetErrorExpectation = expectation(description: "Request should fail for offset param")
        // When
        ProductsServices.getProductsList(byQuery: query, limit: limit, andOffset: offset) { result in
            // Then
            switch result {
            case let .success(productsList):
                XCTAssertGreaterThan(productsList.count, 1)
                requestExpectation.fulfill()
            case .failure:
                XCTFail("Request should succeed")
            }
        }

        // When
        ProductsServices.getProductsList(byQuery: "", limit: limit, andOffset: offset) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Request should fail")
            case let .failure(err):
                XCTAssertEqual(ApiError.invalidParameters, err)
                requestQueryErrorExpectation.fulfill()
            }
        }

        // When
        ProductsServices.getProductsList(byQuery: query, limit: 0, andOffset: offset) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Request should fail")
            case let .failure(err):
                XCTAssertEqual(ApiError.invalidParameters, err)
                requestLimitErrorExpectation.fulfill()
            }
        }

        // When
        ProductsServices.getProductsList(byQuery: query, limit: limit, andOffset: -1) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Request should fail")
            case let .failure(err):
                XCTAssertEqual(ApiError.invalidParameters, err)
                requestOffsetErrorExpectation.fulfill()
            }
        }

        wait(for: [requestExpectation,
                   requestQueryErrorExpectation,
                   requestLimitErrorExpectation,
                   requestOffsetErrorExpectation],
             timeout: 10.0)
    }
}
