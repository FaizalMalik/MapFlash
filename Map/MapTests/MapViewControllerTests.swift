//
//  MapTests.swift
//  MapTests
//
//  Created by faizal on 17/03/19.
//  Copyright © 2019 test. All rights reserved.
//

import XCTest
import MapKit

@testable import Map

class MapViewControllerTests: XCTestCase {
    
    var controllerUnderTest: MapViewController!
    var testMap : MKMapView?
    
    override func setUp() {
          super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        controllerUnderTest = MapViewController()
        testMap = MKMapView()
        
        controllerUnderTest.mapView = testMap
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
        XCTAssertNotEqual(String(describing: popupView), "VehicleDetailView", "Wrong Identifier")
    }
    
    func testAddAnnotationMethod(){
   
        /*This method is for Testing that Adding notation to Map is working correctly,
        for that we inject six dummy data as annotation array
         */
        guard let data = FileManager.readJson(forResource: "Sample") else {
            XCTAssert(false, "Can't get data from sample.json")
            return
        }
        
        do {
           
            // given
            let promise = expectation(description: "controllerUnderTest.mapView annotation count will be six")
            
            let dummyVehiclesArray = try JSONDecoder().decode([Vehicle].self, from: data)
            
            //Setting dummy map as sut map
            controllerUnderTest.mapView = testMap
            
           let dummyAnnotationArray = dummyVehiclesArray.map({return VehicleAnnotation(vehicle: $0)})
            
            //When
            controllerUnderTest.addAnnotations(forVehilces: dummyAnnotationArray) {
                
                //then
                
                XCTAssertEqual(self.controllerUnderTest.mapView.annotations.count, dummyAnnotationArray.count,"Mapview added annotation count not same as injected annotation count")
                
                promise.fulfill()
           }
            
            
            

            
            
            
        } catch _ {
            XCTFail("Failed to decode:")
            
        }
            
          waitForExpectations(timeout: 5, handler: nil)
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

extension FileManager {
    
    static func readJson(forResource fileName: String ) -> Data? {
        
        let bundle = Bundle(for: MapViewControllerTests.self)
        if let path = bundle.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                // handle error
            }
        }
        
        return nil
    }
}
