//
//  VehicleDetailViewTests.swift
//  MapTests
//
//  Created by faizal on 17/03/19.
//  Copyright © 2019 test. All rights reserved.
//

import XCTest
@testable import Map

class VehicleDetailViewTests: XCTestCase {
    var sut: VehicleDetailView!
    var mapViewController : MapViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        mapViewController = MapViewController()
        sut = mapViewController.loadPopupView()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
         sut = nil
        mapViewController = nil
        super.tearDown()
        
    }

    func testBindData() {
        //Expecting the Vehicles details pop up showing same data as we provide 
        // given
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "Sample", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        do {
            // when
            let vehiclesArray = try JSONDecoder().decode([Vehicle].self, from: data!)
            
            //Selecting a random element considered as selected vehicle
            let dummyVehicle = vehiclesArray.randomElement()
            
            sut.vehicle = dummyVehicle!
            
            
            XCTAssertEqual(sut.vehicle.name, dummyVehicle!.name, "Vehicle name binding failed")
            
            XCTAssertEqual(sut.vehicle.description, dummyVehicle!.description, "Vehicle name binding failed")
            XCTAssertEqual(sut.vehicle.batteryLevel, dummyVehicle!.batteryLevel, "Vehicle batteryLevel binding failed")
            XCTAssertEqual(sut.vehicle.price, dummyVehicle!.price, "Vehicle name price failed")
            XCTAssertEqual(sut.vehicle.currency, dummyVehicle!.currency, "Vehicle currency binding failed")


        } catch _ {
            XCTFail("Failed to decode:")
        }
        
    }

  

}
