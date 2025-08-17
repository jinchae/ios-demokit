//
//  DemoKitUITests.swift
//  DemoKitUITests
//
//  Created by 정진채 on 8/17/25.
//

import XCTest

final class DemoKitMVCUITests: XCTestCase {
    func testListLoads() {
        let app = XCUIApplication()
        app.launch()
        let list = app.collectionViews["product_list"]
        XCTAssertTrue(list.waitForExistence(timeout: 10))   // 여유 10초

        let firstCell = list.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
    }
}
