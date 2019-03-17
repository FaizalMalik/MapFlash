//
//  MapTests.swift
//  MapTests
//
//  Created by faizal on 14/03/19.
//  Copyright © 2019 test. All rights reserved.
//

import XCTest
@testable import Map

class MapApiServiceTests: XCTestCase {
    var mapServiceTest: MapService?
    
    override func setUp() {
            super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mapServiceTest = MapService()
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mapServiceTest = nil
        super.tearDown()

    }

    func testFetchAllVehiclesGetsHTTPStatusCode200() {
       
        // given
        let promise = expectation(description: "FetchAllVehicles Api call executed successfully")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        mapServiceTest?.fetchAllVehicles(completion: { (vehiclesArray, response, error) in
            
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            // 2
            promise.fulfill()
            
        })
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)

    }

    
    func testFetchVehilceDetailsCall(){
        
        // given
        let promise = expectation(description: "Fetching vehicle details successfully")
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "Sample", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        do {
            // when
            let vehiclesArray = try JSONDecoder().decode([Vehicle].self, from: data!)
            
            //Selecting a random element considered as selected vehicle
            let selectedVehicle = vehiclesArray.randomElement()
            
            mapServiceTest?.fetchVehilceDetails(vechileID: (selectedVehicle?.id)!, completion: { (vehicle, response, error) in
                
                let statusCode = (response as? HTTPURLResponse)?.statusCode


                // then
                XCTAssertEqual(statusCode, 200)
                XCTAssertNotNil(vehicle,"Failed to parse vehicle Model")
                XCTAssertEqual(selectedVehicle?.id, vehicle?.id, "vehicle")

               promise.fulfill()
                
                
            })
            
            
            
           
        } catch _ {
            XCTFail("Failed to decode:")
        }
        
         waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    

}
