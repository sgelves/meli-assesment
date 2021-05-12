//
//  ProductIpadVC.swift
//  meli assesmentTests
//
//  Created by Sergio Gelves on 5/05/21.
//

@testable import meli_assesment
import XCTest

class ProductListPresenterMock: ProductListPresProtocol {

    var service: ProductsServiceProtocol.Type = ProductsServicesMock.self

    weak var view: ProductListViewProtocol? = nil

    var products: [Product] = []

    var query: String = ""

    var isLoading: Bool = false

    var limit: Int = 10

    func setQuery(_ query: String) {
        self.query = query
    }

    func searchProducts() {
        service.getProductsList(byQuery: "", limit: 10, andOffset: 0) {  [weak self] result in
            if case let .success(products) = result {
                self?.products = products
                self?.view?.reloadView(state: .withData)
            }
        }
    }
}

class ProductListIpadVCTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreation() throws {

        // GIVEN
        let vc = ProductListIpadVC()
        let viewType: ProductListViewProtocol? = vc
        let searchType: SearchResultDelegateProtocol? = vc

        let presenter = ProductListPresenterMock()
        presenter.view = vc

        vc.presenter = presenter

        // WHEN
        vc.loadViewIfNeeded()

        // THEN
        XCTAssertNotNil(viewType)
        XCTAssertNotNil(searchType)

        XCTAssertNotNil(vc.collectionView)
        XCTAssertNotNil(vc.collectionView.dataSource)
        XCTAssertNotNil(vc.collectionView.delegate)

        XCTAssertEqual(vc.collectionView.dataSource?.collectionView(vc.collectionView, numberOfItemsInSection:0), 0)

        // WHEN
        let query = "Test"
        vc.souldUpdateResult(withSearchValue: query)

        // THEN
        let expc = expectation(description: "should have data")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {

            XCTAssertEqual(vc.collectionView.dataSource?.collectionView(vc.collectionView, numberOfItemsInSection:0), presenter.limit)

            let initIndexPath = IndexPath(row: 0, section: 0)
            let cell = vc.collectionView(vc.collectionView, cellForItemAt: initIndexPath) as? ProductIpadCollectionViewCell

            XCTAssertNotNil(cell)

            XCTAssertEqual(cell?.titleLabel.text, presenter.products[0].title)

            expc.fulfill()
        }

        wait(for: [expc], timeout: 1)
    }
}
