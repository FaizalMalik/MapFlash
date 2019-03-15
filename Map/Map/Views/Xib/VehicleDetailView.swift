//
//  VehicleDetailView.swift
//  Map
//
//  Created by faizal on 14/03/19.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class VehicleDetailView: UIView {

    
 // MARK: - Outlets
    @IBOutlet weak var imgScooter: UIImageView!
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var lblVehicleName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblBatteryLevel: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    // MARK: - Properties
   
    var vehicle : Vehicle!{
        didSet{
            bindData()
        }
    }
    override func awakeFromNib() {
        setupView()
    }
    
    
    // MARK: - Setup Methods
    func setupView()  {
        
        //Setting border
        setBorder(of: self.baseView, borderColor: (Constants.borderColor).cgColor, borderWidth: 2, cornerRadius: 5)
        
        setBorder(of: imgScooter, borderColor: (Constants.borderColor).cgColor, borderWidth: 2, cornerRadius:imgScooter.frame.height/2)
        imgScooter.clipsToBounds = true

       
    }
    
    func bindData() {
        
        lblVehicleName.text = self.vehicle.name
        lblDescription.text = self.vehicle.description
        lblBatteryLevel.text = "\(self.vehicle.batteryLevel)"
        lblPrice.text = self.vehicle.currency + " " + "\(self.vehicle.price)"

    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
