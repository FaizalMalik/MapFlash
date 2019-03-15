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
    let apiService: MapServiceProtocol = MapService()
    
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
    
    
    // MARK: - Popup View Method
    
    private  func removePopUpView(of annotation : VehicleAnnotation){
    DispatchQueue.main.async {
                let annotationView = self.mapView.view(for: annotation)
                for subview in annotationView!.subviews
                {
                    subview.removeFromSuperview()
                }
            }
        }
    
    private  func showPopUpView(on view : MKAnnotationView, of vehicle:Vehicle){
        DispatchQueue.main.async {
            let views = Bundle.main.loadNibNamed(VehicleDetailView.reuseIdentifier, owner: nil, options: nil)
            let popUpView = views?[0] as! VehicleDetailView
            popUpView.vehicle = vehicle
            popUpView.center = CGPoint(x: view.bounds.size.width / 2, y: -popUpView.bounds.size.height*0.52)
            view.addSubview(popUpView)
        }
    }
    
    
   // MARK: - Network Calls
    fileprivate func fetchData() {
        showActivityIndicator()
        
        apiService.fetchAllVehicles { (vehicles, response ,error) in
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
        apiService.fetchVehilceDetails(vechileID: selectedVehicle.id) { (vehicle,response, error) in
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
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation as? VehicleAnnotation else {
            // Return execution if its not at Vehicle Pin
            return
        }
        
        //For a successfull tap, change the region of map to center of tapped cordinate.
        centerMap(on: annotation.coordinate)
        
        //If any vehicle vehicle details already displayed, then remove popup
        if(selectedAnnotation != nil){
            removePopUpView(of: selectedAnnotation!)
        }
        
        
        //checking case, if tapped pin is same as previous selected pin,
        if selectedAnnotation == annotation {
            
            selectedAnnotation=nil
            
        }
        else{
            // Fetch the details of selected vehicle
            
            fetchVehicleDetails(selectedVehicle: annotation.vehicle) { (vehicle) in
             
                //Set selected vehicle
                self.selectedAnnotation = annotation
                
                self.showPopUpView(on: view, of: vehicle)
                
            }
        }
        
        //Deselecting the current annotation , to get call back on next click.
        mapView.deselectAnnotation(annotation, animated: false)
        
    }
    
    private func centerMap(on coordinate: CLLocationCoordinate2D) {
        
        let regionRadius: CLLocationDistance = 3000
        let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    private func addAnnotations(forVehilces vehiclesAnnotationArray:[VehicleAnnotation]) {
        DispatchQueue.main.async {
        if  vehiclesAnnotationArray.count > 0 {
            //Set the first pin as center
            self.centerMap(on: vehiclesAnnotationArray[0].coordinate)
            
            for annotation in vehiclesAnnotationArray {
               
                
                self.mapView.addAnnotation(annotation)
            }
            
            
        }
    }
    }
}

