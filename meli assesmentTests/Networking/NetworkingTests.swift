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

    private func readLocalFile(forName name: String) throws -> Data?  {

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
                XCTFail()
            }
        }

        wait(for: [requestExpectation], timeout: 100.0)
    }
}
