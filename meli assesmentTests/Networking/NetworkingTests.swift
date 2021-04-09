//
//  NetworkingTests.swift
//  meli assesmentTests
//
//  Created by Sergio Gelves on 8/04/21.
//

import XCTest
import Mocker
import Alamofire

@testable import meli_assesment

class NetworkingTests: XCTestCase {

    private var sessionManager: Session?

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

        sessionManager = Session(configuration: configuration)
    }

    override func tearDownWithError() throws {
        sessionManager = Session()
    }

    func testExecute() throws {
        // Given
        let apiEndpoint = URL(string: "\(Networking.Domain.develop.rawValue)/example")!
        let jsonData = try readLocalFile(forName: "ProductQueryResponse")

        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 200, data: [.get: jsonData!])
        mock.register()

        let requestExpectation = expectation(description: "Request should finish")
        // When
        Networking.sessionManager = sessionManager!
        Networking(path: "/example", parameters: [:]).execute(withCodable: ProductResponse.self) { result in
            // Then
            switch result {
            case .success:
                requestExpectation.fulfill()
            case let .failure(err):
                debugPrint(err)
                XCTFail("Request should succeed")
            }
        }

        wait(for: [requestExpectation], timeout: 10.0)
    }

    func testExecuteErrors() throws {
        // Given
        let apiPost = URL(string: "\(Networking.Domain.develop.rawValue)/examplePost")!
        let apiNetworkEndpoint = URL(string: "\(Networking.Domain.develop.rawValue)/exampleNetwork")!
        let api200Endpoint = URL(string: "\(Networking.Domain.develop.rawValue)/example200")!
        let api400Endpoint = URL(string: "\(Networking.Domain.develop.rawValue)/example400")!
        let api500Endpoint = URL(string: "\(Networking.Domain.develop.rawValue)/example500")!

        let mockPost = Mock(url: apiPost, dataType: .html, statusCode: 405, data:  [.post: Data()])
        let mockNetwork = Mock(url: apiNetworkEndpoint, dataType: .html, statusCode: 0, data:  [.get: Data()])
        let mock200 =
            Mock(url: api200Endpoint, dataType: .json, statusCode: 200, data: [.get: "{}".data(using: .utf8)!])
        let mock400 = Mock(url: api400Endpoint, dataType: .json, statusCode: 400, data: [.get: Data()])
        let mock500 = Mock(url: api500Endpoint, dataType: .json, statusCode: 500, data: [.get: Data()])

        mockPost.register()
        mockNetwork.register()
        mock200.register()
        mock400.register()
        mock500.register()

        let requestPostShouldFail = expectation(description: "Request /examplePost should fail")
        let requestNetworkShouldFail = expectation(description: "Request /exampleNetwork should fail")
        let request200ShouldFail = expectation(description: "Request /example200 should fail")
        let request400ShouldFail = expectation(description: "Request /example400 should fail")
        let request500ShouldFail = expectation(description: "Request /example500 should fail")

        // When
        Networking.sessionManager = sessionManager!

        Networking(path: "/examplePost", method: .post).execute(withCodable: ProductResponse.self) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Request should fai")
            case let .failure(error):
                XCTAssertEqual(error, ApiError.methodNotAllowed)
                requestPostShouldFail.fulfill()
            }
        }
        Networking(path: "/exampleNetwork").execute(withCodable: ProductResponse.self) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Request should fai")
            case let .failure(error):
                XCTAssertEqual(error, ApiError.connectionError)
                requestNetworkShouldFail.fulfill()
            }
        }

        Networking(path: "/example200").execute(withCodable: ProductResponse.self) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Request should fai")
            case let .failure(error):
                XCTAssertEqual(error, ApiError.jsonParseError)
                request200ShouldFail.fulfill()
            }
        }

        Networking(path: "/example400").execute(withCodable: ProductResponse.self) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Request should fai")
            case let .failure(error):
                XCTAssertEqual(error, ApiError.invalidRequest)
                request400ShouldFail.fulfill()
            }
        }

        Networking(path: "/example500").execute(withCodable: ProductResponse.self) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Request should fai")
            case let .failure(error):
                XCTAssertEqual(error, ApiError.serverError)
                request500ShouldFail.fulfill()
            }
        }

        wait(for: [requestPostShouldFail,
                   requestNetworkShouldFail,
                   request200ShouldFail,
                   request400ShouldFail,
                   request500ShouldFail],
             timeout: 10.0)
    }
}
