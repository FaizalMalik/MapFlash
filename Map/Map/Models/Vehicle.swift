//
//  Vehicle.swift
//  MapTest
//
//  Created by faizal on 12/03/19.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import MapKit
struct Vehicle:Decodable {
    let id : Int
    let name : String
    let description : String
    let latitude : Double
    let longitude : Double
    let batteryLevel : Int
    let timestamp : String
    let price : Double
    let priceTime : Double
    let currency : String
}

class VehicleAnnotation: NSObject {
    let vehicle : Vehicle
    
    init(vehicle : Vehicle) {
        self.vehicle =  vehicle
    }
}

extension VehicleAnnotation:MKAnnotation{
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: vehicle.latitude, longitude: vehicle.longitude)

    }
}
