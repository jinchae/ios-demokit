//
//  DemoKitTests.swift
//  DemoKitTests
//
//  Created by 정진채 on 8/17/25.
//

import XCTest
@testable import DemoKit

final class ProductParsingTests: XCTestCase {
    func testDecodeProductsFromBundle() throws {
        let url = try XCTUnwrap(Bundle.main.url(forResource: "products", withExtension: "json"),"not found")
        let data = try Data(contentsOf: url)
        let list = try JSONDecoder().decode([Product].self, from: data)
        XCTAssertGreaterThan(list.count, 0)
        XCTAssertNotNil(list.first?.id)
    }
}

