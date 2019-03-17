//
//  MapTests.swift
//  MapTests
//
//  Created by faizal on 17/03/19.
//  Copyright © 2019 test. All rights reserved.
//

import XCTest
@testable import Map

class MapTests: XCTestCase {
    var controllerUnderTest: MapViewController!

    override func setUp() {
          super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        controllerUnderTest = MapViewController()
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        controllerUnderTest = nil
      super.tearDown()
    }

    func testLoadPopupView() {
        
        // Expecting to load the pop up view without fail
       
        // when
        
       let popupView =  controllerUnderTest.loadPopupView()
        
        
        //then
        XCTAssertNotNil(popupView.self)
        
    }
    
    func testRemovePopupViewMethod(){
        
        
    }

    func testFetchVehicleDetailsMethod(){
        
        //Given
        let promise = expectation(description: "Expected failure when wrong data")
        let vehicleDummy = Vehicle(id: -9999, name: "", description: "", latitude: -999, longitude: -999, batteryLevel: -99, timestamp: "", price: -99, priceTime: -99, currency: "")
        
        var failureCallback = false
        //when
        controllerUnderTest.fetchVehicleDetails(selectedVehicle: vehicleDummy, completion: { (vehicle) in
           
            promise.fulfill()
        }, failure: { (result) in
            
            failureCallback = true

            promise.fulfill()
            
        })
        
        
        waitForExpectations(timeout: 105, handler: nil)
        //then
         XCTAssertEqual(failureCallback, true)
    }
    
    
    
    
}
