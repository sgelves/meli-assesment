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

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testProductListPresented() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        app.navigationBars["meli_assesment.ProductListVC"].searchFields["Buscar"].tap()

        let mKey = app/*@START_MENU_TOKEN@*/.keys["M"]/*[[".keyboards.keys[\"M\"]",".keys[\"M\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        mKey.tap()

        let aKey = app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        aKey.tap()

        let qKey = app/*@START_MENU_TOKEN@*/.keys["q"]/*[[".keyboards.keys[\"q\"]",".keys[\"q\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        qKey.tap()

        let app2 = app
        app2/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"buscar\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()

        XCTAssertTrue(app.tables.cells.otherElements.containing(
                        .image,
                        identifier:"Imagen del producto en la celda MCO608744399").element.exists)

        app.tables.cells.otherElements.containing(
            .image,
            identifier:"Imagen del producto en la celda MCO608744399").element.tap()

        let scrollViewsQuery = app.scrollViews

        XCTAssertTrue(scrollViewsQuery.otherElements.containing(
                        .staticText,
                        identifier:"Título del detalle del producto").children(matching: .other).element.exists)
        scrollViewsQuery.otherElements.containing(
            .staticText,
            identifier:"Título del detalle del producto").children(matching: .other).element.tap()
        
        let atrSButton = app.navigationBars["meli_assesment.ProductVC"].buttons["Atrás"]
        atrSButton.tap()

        let tablesQuery = app2.tables
        XCTAssertTrue(tablesQuery.cells.staticTexts["Envío del producto en la celda MCO552813380"].exists)
        tablesQuery.cells.staticTexts["Envío del producto en la celda MCO552813380"].tap()

        let elementsQuery = scrollViewsQuery.otherElements
        XCTAssertTrue(elementsQuery.staticTexts["Envío del detalle del producto"].exists)
        elementsQuery.staticTexts["Envío del detalle del producto"].tap()

        atrSButton.tap()

        XCTAssertTrue(tablesQuery.staticTexts["Título del producto en la celda MCO552813380"].exists)
        tablesQuery.staticTexts["Título del producto en la celda MCO552813380"].tap()

        XCTAssertTrue(elementsQuery.staticTexts["Título del detalle del producto"].exists)
        elementsQuery.staticTexts["Título del detalle del producto"].tap()

        atrSButton.tap()

        XCTAssertTrue(tablesQuery.staticTexts["Precio del producto en la celda MCO607778497"].exists)
        tablesQuery.staticTexts["Precio del producto en la celda MCO607778497"].tap()

        XCTAssertTrue(elementsQuery.staticTexts["Precio del detalle del producto"].exists)
        elementsQuery.staticTexts["Precio del detalle del producto"].tap()
    }
}
