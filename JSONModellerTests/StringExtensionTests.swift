//
//  StringExtensionTests.swift
//  JSONModeller
//
//  Created by Johnykutty Mathew on 06/06/15.
//  Copyright (c) 2015 Johnykutty Mathew. All rights reserved.
//

import Cocoa
import XCTest

class StringExtensionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSubStringFrom() {
        let string = "test"
        let expectedResult = "est"
        let actualResult = string.substring(from:1)
        XCTAssertEqual(expectedResult, actualResult, "testSubStringFrom failed for lowercase string")
        
        let string2 = "TEST"
        let expectedResult2 = "EST"
        let actualResult2 = string2.substring(from:1)
        XCTAssertEqual(expectedResult, actualResult, "testSubStringFrom failed for uppercase string")
    }
    
    func testSubStringTo() {
        let string = "Test"
        let expectedResult = "Te"
        let actualResult = string.substring(to:2)
        XCTAssertEqual(expectedResult, actualResult, "testSubStringTo failed for lowercase string")
      
        let string2 = "TEST"
        let expectedResult2 = "TE"
        let actualResult2 = string2.substring(to:2)
        XCTAssertEqual(expectedResult2, actualResult2, "testSubStringTo failed for failed for uppercase string")
    }
    
    func testfirstLetterLowered() {
        let string = "Test"
        let expectedResult = "test"
        let actualResult = string.firstLetterLoweredString()
        XCTAssertEqual(expectedResult, actualResult, "firstLetterLowerdString failed for lowecase string")
        
        let string2 = "TEST"
        let expectedResult2 = "tEST"
        let actualResult2 = string2.firstLetterLoweredString()
        XCTAssertEqual(expectedResult2, actualResult2, "firstLetterLowerdString failed for uppercase string")
    }
    
    func testfirstLetterLoweredForSingleLetter() {
        let string = "T"
        let expectedResult = "t"
        let actualResult = string.firstLetterLoweredString()
        XCTAssertEqual(expectedResult, actualResult, "firstLetterLowerdString failed for lsingle lettor string")
    }

}
