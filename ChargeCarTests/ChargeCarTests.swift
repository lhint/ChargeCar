//
//  ChargeCarTests.swift
//  ChargeCarTests
//
//  Created by Luke Hinton on 03/09/2021.
//

import XCTest
@testable import ChargeCar

//Guide to unit testing: https://www.raywenderlich.com/21020457-ios-unit-testing-and-ui-testing-tutorial

class ChargeCarTests: XCTestCase {
    var sut: HomeViewController!
    var sut2: Book!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = HomeViewController()
        sut2 = Book()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        sut2 = nil
        try super.tearDownWithError()
    }
    
    func testPrivateChargerData_ShouldReturnNone() {
        //arrange

        //act
        let newCharger = PrivateChargerData()
        let count = newCharger.chargerName?.count

        //assert
        XCTAssertEqual(nil, count)
    }
    
    func testPrivateChargerData_ShouldSetAllProperties() {
        //arrange
        
        //act
        let newCharger = PrivateChargerData()
        newCharger.chargerName = "Test Charger"
        newCharger.chargerLat = "54.8653"
        newCharger.chargerLong = "-6.2802"
        newCharger.chargerKW1 = "6"
        newCharger.chargerConnector1 = "Type2"
        newCharger.price = "0.00"
        newCharger.free = "true"
        newCharger.hostUid = "0001"
        
        //assert
        XCTAssertNotNil(newCharger)
        XCTAssertEqual("Test Charger", newCharger.chargerName)
        XCTAssertEqual("54.8653", newCharger.chargerLat)
        XCTAssertEqual("-6.2802", newCharger.chargerLong)
        XCTAssertEqual("6", newCharger.chargerKW1)
        XCTAssertEqual("Type2", newCharger.chargerConnector1)
        XCTAssertEqual("0.00", newCharger.price)
        XCTAssertEqual("true", newCharger.free)
        XCTAssertEqual("0001", newCharger.hostUid)
    }
    
    func testCurrentLocation_IsNotNill() {
        //arrange

        //act
        let savedLocationLat = Global.shared.currentLat
        let savedLocationLong = Global.shared.currentLong

        //assert
        XCTAssertNotNil(savedLocationLat)
        XCTAssertNotNil(savedLocationLong)

    }
    
    func testSetFutureDate_IsNotNill() {
        //arrange
        
        //act
        let date = sut2.setFutureDate(chosenDay: "Monday")
        //assert
        XCTAssertNotNil(date)
    }
    
    func testSignedIn() {
        //arrange
        
        //act
        let signedIn = Global.shared.signedIn
    
        //assert
        XCTAssertEqual(true, signedIn)
    }
    
}
