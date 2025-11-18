//
//  BitcoinRadarUITests.swift
//  BitcoinRadarUITests
//
//  Created by Hossein Asadiparchenaki on 14.11.25.
//

import XCTest

final class BitcoinRadarUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testHistoryListDisplaysStubbedRows() {
        let app = launchApp(for: .listSuccess)

        let firstRow = app.buttons["list_row_link_1700000000"]
        XCTAssertTrue(firstRow.waitForExistence(timeout: 3))

        XCTAssertTrue(app.buttons["list_row_link_1699913600"].exists)
    }

    func testSelectingRowShowsDetailScreen() {
        let app = launchApp(for: .listSuccess)

        let firstRow = app.buttons["list_row_link_1700000000"]
        XCTAssertTrue(firstRow.waitForExistence(timeout: 3))
        firstRow.tap()

        let detailContainer = app.otherElements["detail_prices_container"]
        XCTAssertTrue(detailContainer.waitForExistence(timeout: 3))

        XCTAssertTrue(app.otherElements["detail_price_row_EUR"].exists)
        XCTAssertTrue(app.otherElements["detail_price_row_USD"].exists)
        XCTAssertTrue(app.otherElements["detail_price_row_GBP"].exists)
    }

    func testHistoryListShowsErrorState() {
        let app = launchApp(for: .listError)

        let errorMessage = app.staticTexts["list_error_message"]
        XCTAssertTrue(errorMessage.waitForExistence(timeout: 3))
    }

    // MARK: - Helpers

    private func launchApp(for scenario: UITestScenario) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchEnvironment["UITEST_SCENARIO"] = scenario.rawValue
        app.launch()
        return app
    }
}

private enum UITestScenario: String {
    case listSuccess = "list_success"
    case listError = "list_error"
}
