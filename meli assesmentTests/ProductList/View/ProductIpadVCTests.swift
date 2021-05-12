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

    var vc: ProductListIpadVC!
    var presenter: ProductListPresenterMock!
    var viewType: ProductListViewProtocol?
    var searchType: SearchResultDelegateProtocol?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        vc = ProductListIpadVC()
        viewType = vc
        searchType = vc

        presenter = ProductListPresenterMock()
        presenter.view = vc

        vc.presenter = presenter

        vc.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReloadState() throws {

        // WHEN
        let query = "Test"
        vc.souldUpdateResult(withSearchValue: query)

        // THEN
        let expcData = expectation(description: "should have data")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in

            guard let vc = self?.vc, let presenter = self?.presenter else {
                XCTAssertThrowsError("View was disposed")
                return
            }

            XCTAssertEqual(vc.listSate, ListViewState.withData)

            XCTAssertEqual(vc.collectionView.dataSource?.collectionView(vc.collectionView, numberOfItemsInSection:0),
                           presenter.limit)

            expcData.fulfill()
        }

        wait(for: [expcData], timeout: 1)
    }

    func testCellsCreation() throws {

        // WHEN
        let query = "Test"
        vc.souldUpdateResult(withSearchValue: query)

        // THEN
        XCTAssertNotNil(viewType)
        XCTAssertNotNil(searchType)

        XCTAssertNotNil(vc.collectionView)
        XCTAssertNotNil(vc.collectionView.dataSource)
        XCTAssertNotNil(vc.collectionView.delegate)

        // THEN
        let expc = expectation(description: "should have data")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in

            guard let vc = self?.vc, let presenter = self?.presenter else {
                XCTAssertThrowsError("View was disposed")
                return
            }

            XCTAssertEqual(vc.collectionView.dataSource?.collectionView(vc.collectionView, numberOfItemsInSection:0),
                           presenter.limit)

            var index = 0
            for product in presenter.products {

                let initIndexPath = IndexPath(row: index, section: 0)
                let cell = vc.collectionView(vc.collectionView, cellForItemAt: initIndexPath)
                    as? ProductIpadCollectionViewCell

                XCTAssertNotNil(cell)

                XCTAssertEqual(cell!.titleLabel.text!, product.title)
                XCTAssertNotNil(cell?.priceLabel)
                XCTAssertNotNil(cell?.discountLabel)
                XCTAssertNotNil(cell?.segmentedLabel)
                XCTAssertNotNil(cell?.shippingLabel)
                XCTAssertNotNil(cell?.thumbnailView)

                index += 1
            }


            let cell = vc.collectionView(vc.collectionView, cellForItemAt: IndexPath(row: 0, section: 0))
            let expectedWidth = vc.collectionView.bounds.width/3.0 - vc.cvCellSpacing*(vc.cvCellAmount - 1) //

            XCTAssertEqual(cell.bounds.width, expectedWidth)

            expc.fulfill()
        }

        wait(for: [expc], timeout: 1)
    }
}
