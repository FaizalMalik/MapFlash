//
//  ViewController.swift
//  Map
//  Created by faizal on 14/03/19.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    var selectedAnnotation : VehicleAnnotation?
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupView()
        fetchData()
    }

    // MARK: - View Related Methods
    fileprivate func setupView() {
        
        // Add activity Indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
    }
   fileprivate func showActivityIndicator(){
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
   fileprivate func hideActivityIndicator(){
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    
    
   // MARK: - Network Calls
    fileprivate func fetchData() {
        showActivityIndicator()
        
        MapService.shared.fetchAllVehicles { (vehicles, response ,error) in
            self.hideActivityIndicator()
           
            guard let vehicles = vehicles,
                error == nil else {
                    print("Failed to fetch vehicles:: \(String(describing: error))")
                    return
            }
            //Creating array of vehicle annotation to plot pin on map
            let vehiclesArray = vehicles.map({return VehicleAnnotation(vehicle: $0)})
            
            self.addAnnotations(forVehilces: vehiclesArray)
            
        }
        
        
    }
    func fetchVehicleDetails(selectedVehicle : Vehicle,completion : @escaping (_ result: Vehicle)->()) {
        showActivityIndicator()
        MapService.shared.fetchVehilceDetails(vechileID: selectedVehicle.id) { (vehicle,response, error) in
             self.hideActivityIndicator()
             guard let vehicle = vehicle,
                error == nil else {
                    print("Fetching details failed: \(String(describing: error))")
                    return
            }
            completion(vehicle)
            
            
        }
        
    }
}


extension ViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is VehicleAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = false
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    
   
    private func centerMap(on coordinate: CLLocationCoordinate2D) {
        
        let regionRadius: CLLocationDistance = 3000
        let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    private func addAnnotations(forVehilces vehiclesAnnotationArray:[VehicleAnnotation]) {
        if  vehiclesAnnotationArray.count > 0 {
            //Set the first pin as center
            self.centerMap(on: vehiclesAnnotationArray[0].coordinate)
            
            for annotation in vehiclesAnnotationArray {
               
                
                self.mapView.addAnnotation(annotation)
            }
            
            
        }
    }
    
}

