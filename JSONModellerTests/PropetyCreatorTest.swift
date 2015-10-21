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
        let creator = PropertyInfo()
        let propertyName = "&&) This is @@a ()(test   %&&  property %123"
        let expectedResult = "thisIsATestProperty123"
        let actualResult = creator.propertyNameFrom(propertyName)
        XCTAssertEqual(expectedResult, actualResult, "remove special chars failed")
    }
    
    func testAlreadyCamelCased() {
        let creator = PropertyInfo()
        let propertyName = "&&) This is @@a ()(testProperty %123"
        let expectedResult = "thisIsATestProperty123"
        let actualResult = creator.propertyNameFrom(propertyName)
        XCTAssertEqual(expectedResult, actualResult, "AlreadyCamelcased failed")
    }

    func testStartingWithDigit() {
        let creator = PropertyInfo()
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
        let creator = PropertyInfo()
        let propertyName = "8&&) this ??`is  a68testProperty %123"
        let expectedResult = "_8ThisIsA68TestProperty123"
        let actualResult = creator.propertyNameFrom(propertyName)
        XCTAssertEqual(expectedResult, actualResult, "starting with digits test failed")

    }
    
    func _testNumberTypes() {
        //just checking
        let creator = PropertyInfo()
        var number = NSNumber(bool: true)
        var type = String.fromCString(number.objCType)!
        print("bool ", terminator: "")
        print(type)
        number = NSNumber(booleanLiteral: true)
        type = String.fromCString(number.objCType)!
        print("booleanLiteral ", terminator: "")
        print(type)
        number = NSNumber(float: 1.1)
        type = String.fromCString(number.objCType)!
        print("float ", terminator: "")
        print(type)
        
        number = NSNumber(floatLiteral: 1.1)
        type = String.fromCString(number.objCType)!
        print("floatLiteral ", terminator: "")
        print(type)
        
        number = NSNumber(int: 1)
        type = String.fromCString(number.objCType)!
        print("int ", terminator: "")
        print(type)
        
        number = NSNumber(integerLiteral: 2)
        type = String.fromCString(number.objCType)!
        print("integerLiteral ", terminator: "")
        print(type)
        
        number = NSNumber(integer: 1)
        type = String.fromCString(number.objCType)!
        print("integer ", terminator: "")
        print(type)
        
        number = NSNumber(longLong: 1000000000000000000)
        type = String.fromCString(number.objCType)!
        print("longLong ", terminator: "")
        print(type)
    }
}
