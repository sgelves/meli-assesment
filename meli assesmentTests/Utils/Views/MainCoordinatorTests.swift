//
//  MainCoordinatorTests.swift
//  meli assesmentTests
//
//  Created by Sergio Gelves on 13/05/21.
//

import XCTest
@testable import meli_assesment

class MainCoordinatorTests: XCTestCase {

    override func tearDownWithError() throws {
        MainCoordinator.coordinator = nil
    }

    func testStart() throws {
        //GIVEN
        let coordinator = MainCoordinator.start()

        // WHEN
        XCTAssertNotNil(coordinator)

        //THEN
        if UIDevice.current.userInterfaceIdiom == .phone {
            XCTAssertTrue(MainCoordinator.coordinator.navController.topViewController is ProductListVC)
        } else {
            XCTAssertTrue(MainCoordinator.coordinator.navController.topViewController is ProductListIpadVC)
        }
    }


    func testNavigateProductDetail() throws {
        //GIVEN
        let _ = MainCoordinator.start()
        
        // WHEN
        MainCoordinator.navigateProductDetai(arg: Product(id: "",
                                                          title: "",
                                                          thumbnail: "",
                                                          price: 0,
                                                          prices: nil,
                                                          shipping: ShippingMethod.init(freeShipping: true)))

        XCTAssertTrue(MainCoordinator.coordinator.navController.topViewController is ProductVC)
    }
}
