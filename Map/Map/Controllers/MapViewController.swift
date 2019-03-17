//
//  ViewController.swift
//  Map
//  Created by faizal on 14/03/19.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Properties
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
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
        activityIndicator.hidesWhenStopped = true
        activityIndicator.frame = CGRect(origin: self.view.center, size: CGSize(width: 80, height: 80))
        activityIndicator.center = self.view.center
        activityIndicator.layer.cornerRadius = 10
        activityIndicator.backgroundColor = Constants.blackColor
        
        self.view.addSubview(activityIndicator)
    }
   fileprivate func showActivityIndicator(){
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            self.activityIndicator.startAnimating()
        }
    }
   fileprivate func hideActivityIndicator(){
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true

            self.activityIndicator.stopAnimating()
        }
    }
    
    
    // MARK: - Popup View Method
    
      func removePopUpView(of annotation : VehicleAnnotation){
     DispatchQueue.main.async {
        if let annotationView = self.mapView.view(for: annotation){
            for subview in annotationView.subviews
            {
                subview.removeFromSuperview()
                
            }
        }
        }
       
    }
    
     func loadPopupView() -> VehicleDetailView {
        
            let views = Bundle.main.loadNibNamed(VehicleDetailView.reuseIdentifier, owner: nil, options: nil)
            let popUpView = views?[0] as! VehicleDetailView
            return popUpView
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
    func fetchVehicleDetails(selectedVehicle : Vehicle,completion : @escaping (_ result: Vehicle)->(),failure : @escaping (_ result: Bool)->()) {
        
        showActivityIndicator()
        
        apiService.fetchVehilceDetails(vechileID: selectedVehicle.id) { (vehicle, response, error) in
            
            self.hideActivityIndicator()
            guard let vehicle = vehicle,
                error == nil else {
                    print("Fetching details failed: \(String(describing: error))")
                    failure(true)
                    return
            }
            completion(vehicle)
            
            
        }
        
        
    }
    
    
}


extension MapViewController : MKMapViewDelegate {
    
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
            
            fetchVehicleDetails(selectedVehicle: annotation.vehicle, completion: { (vehicle) in
                //Set selected vehicle
                self.selectedAnnotation = annotation
                
                DispatchQueue.main.async {
                    let popupView =  self.loadPopupView()
                    popupView.center = CGPoint(x: view.bounds.size.width / 2, y: -popupView.bounds.size.height*0.52)
                    popupView.vehicle = vehicle
                    view.addSubview(popupView)
                }
                
                
            }) { (failure) in
                DispatchQueue.main.async {
                self.showAlert(title: "Failure", message: "Failed to load vehicle Details, Please try again", okAction: {})
                }
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
            if  vehiclesAnnotationArray.count > 0 && (self.mapView != nil){
            //Set the first pin as center
            self.centerMap(on: vehiclesAnnotationArray[0].coordinate)
            
            for annotation in vehiclesAnnotationArray {
               
                
                self.mapView.addAnnotation(annotation)
            }
            
            
        }
    }
    }
}

