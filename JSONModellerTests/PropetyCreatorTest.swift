//
//  PropetyCreatorTest.swift
//  JSONModeller
//
//  Created by Johnykutty Mathew on 31/05/15.
//  Copyright (c) 2015 Johnykutty Mathew. All rights reserved.
//

import Cocoa
import XCTest
import JSONModeller

class PropetyCreatorTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRemoveSpecialCharacters() {
        let creator = PropertyCreator()
        let propertyName = "&&) This is @@a ()(test   %&&  property %123"
        let expectedResult = "thisIsATestProperty123"
        let actualResult = creator.propertyNameFrom(propertyName)
        XCTAssertEqual(expectedResult, actualResult, "remove special chars failed")
    }

    func testStartingWithDigit() {
        let creator = PropertyCreator()
        let propertyName = "123Property"
        let expectedResult = "_123Property"
        let actualResult = creator.propertyNameFrom(propertyName)
        XCTAssertEqual(expectedResult, actualResult, "starting with digits test failed")
    
//        TODO:handle scenario like following - nottice P - lowercase and uppercase
        let propertyName1 = "123property"
        let expectedResult1 = "_123Property"
        let actualResult1 = creator.propertyNameFrom(propertyName1)
        XCTAssertEqual(expectedResult1, actualResult1, "starting with digits test failed")
        
    }
    
    func testFull() {
        let creator = PropertyCreator()
        let propertyName = "8&&) this ??`is @@a68test     property %123"
        let expectedResult = "_8ThisIsA68TestProperty123"
        let actualResult = creator.propertyNameFrom(propertyName)
        XCTAssertEqual(expectedResult, actualResult, "starting with digits test failed")

    }

}
