//
//  MapService.swift
//  Map
//
//  Created by faizal on 15/03/19.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation


class MapService: NSObject {
    
    static let shared = MapService()
    
    // Api call to fetch all vehicles details
    func fetchAllVehicles(completion: @escaping ([Vehicle]?,URLResponse? , Error?) -> ()) {
        
        let apiUrl = Constants.baseUrl + "/vehicles"
        let request = URLRequest(url: URL(string: apiUrl)!)
        
        sessionManager.dataTask(with: request) { (data, response, error) in
            if let err = error {
                completion(nil,response, err)
                print("Failed to fetch courses:", err)
                return
            }
            
            // check response
            
            guard let data = data else { return }
            do {
                let courses = try JSONDecoder().decode([Vehicle].self, from: data)
                DispatchQueue.main.async {
                    completion(courses, response, nil)
                }
            } catch let jsonErr {
                print("Failed to decode:", jsonErr)
            }
            }.resume()
        
    }
    
    func fetchVehilceDetails(vechileID :Int,  completion: @escaping (Vehicle?,URLResponse? , Error?) -> ()) {
        
        let apiUrl = Constants.baseUrl + "/vehicles/\(vechileID)"
        let request = URLRequest(url: URL(string: apiUrl)!)
        
        sessionManager.dataTask(with: request) { (data, response, error) in
            if let err = error {
                completion(nil,response,  err)
                print("Failed to fetch courses:", err)
                return
            }
            
            // check response
            
            guard let data = data else { return }
            do {
                let courses = try JSONDecoder().decode(Vehicle.self, from: data)
                DispatchQueue.main.async {
                    completion(courses,response, nil)
                }
            } catch let jsonErr {
                print("Failed to decode:", jsonErr)
            }
            }.resume()
        
    }
    
    
}
//Mark : Session Manager
private let sessionManager: URLSession = {
    let urlSessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default
    return URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: nil)
}()
