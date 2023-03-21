//
//  Double+Extension+Test.swift
//  WeatherAppTests
//
//  Created by HungNguyen on 2023/03/21.
//

import XCTest
@testable import WeatherApp

final class Double_Extension_Test: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Test Cases
    
    func test_value_will_be_rounded_up_when_decimals_place_bigger_than_0_5() {
        // Given
        let aDouble: Double = 0.6
        
        // When
        let rounded = aDouble.rounded()
        
        // Then
        XCTAssertEqual(rounded, "1")
    }
    
    func test_value_will_be_rounded_down_when_decimals_place_smaller_than_0_5() {
        // Given
        let aDouble: Double = 0.4
        
        // When
        let rounded = aDouble.rounded()
        
        // Then
        XCTAssertEqual(rounded, "0")
    }

}
