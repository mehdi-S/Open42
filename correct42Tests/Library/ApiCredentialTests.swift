//
//  ApiCredentialTests.swift
//  correct42
//
//  Created by larry on 27/04/2016.
//  Copyright © 2016 42. All rights reserved.
//

import XCTest

class ApiCredentialTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testGetSetToken() {
		let testToken = "test"
		
		ApiCredential.Shared().token = testToken
		
		if let token = ApiCredential.Shared().token{
			XCTAssert(token == testToken)
			return
		}
		XCTFail()
	}

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
