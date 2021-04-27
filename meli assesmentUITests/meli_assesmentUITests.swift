//
//  meli_assesmentUITests.swift
//  meli assesmentUITests
//
//  Created by Sergio Gelves on 7/04/21.
//

import XCTest

class MeliAssesmentUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation
        // - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testProductListPresented() throws {
        // UI tests must launch the application that they test.

        // GIVEN
        let app = XCUIApplication()
        app.launch()

        let buscarSearchField = app.navigationBars["meli_assesment.ProductListVC"].searchFields["Buscar"]
        buscarSearchField.tap()
        
        let mKey = app/*@START_MENU_TOKEN@*/.keys["M"]/*[[".keyboards.keys[\"M\"]",".keys[\"M\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        mKey.tap()

        let aKey = app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        aKey.tap()
        
        let qKey = app/*@START_MENU_TOKEN@*/.keys["q"]/*[[".keyboards.keys[\"q\"]",".keys[\"q\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        qKey.tap()

        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"buscar\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()

        let tablesQuery = app.tables

        for index in 0..<3 {

            // WHEN
            let anyCell = tablesQuery.cells.element(boundBy: index).firstMatch

            let titleText = anyCell.staticTexts[AccesibilityIds.ProductCell.title].label
            let priceText = anyCell.staticTexts[AccesibilityIds.ProductCell.price].label

            let hasDiscount = !anyCell.staticTexts[AccesibilityIds.ProductCell.discount].label.isEmpty
            let hasFreeShipping = !anyCell.staticTexts[AccesibilityIds.ProductCell.shipping].label.isEmpty

            // THEN

            // Checko for cell components
            XCTAssertTrue(anyCell.exists)

            XCTAssertTrue(anyCell.staticTexts[AccesibilityIds.ProductCell.title].exists)
            XCTAssertTrue(anyCell.staticTexts[AccesibilityIds.ProductCell.price].exists)
            XCTAssertTrue(anyCell.images[AccesibilityIds.ProductCell.image].exists)

            // Checko for cell's detail components
            anyCell.tap()

            let elementsQuery = app.scrollViews.otherElements
            XCTAssertTrue(elementsQuery.staticTexts[AccesibilityIds.ProductDetail.title].exists)
            XCTAssertTrue(elementsQuery.staticTexts[AccesibilityIds.ProductDetail.price].exists)
            XCTAssertTrue(elementsQuery.images[AccesibilityIds.ProductDetail.image].exists)
            XCTAssertTrue(elementsQuery.staticTexts[AccesibilityIds.ProductDetail.detail].exists)

            if hasDiscount {
                XCTAssertTrue(elementsQuery.staticTexts[AccesibilityIds.ProductDetail.discount].exists)
            }
            if hasFreeShipping {
                XCTAssertTrue(elementsQuery.staticTexts[AccesibilityIds.ProductDetail.shipping].exists)
            }

            XCTAssertEqual(titleText, elementsQuery.staticTexts[AccesibilityIds.ProductDetail.title].label)
            XCTAssertEqual(priceText, elementsQuery.staticTexts[AccesibilityIds.ProductDetail.price].label)


            app.navigationBars["meli_assesment.ProductVC"].buttons.firstMatch.tap() // back button
        }
    }
}
