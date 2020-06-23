//
//  ViewController.swift
//  test
//
//  Created by 김수환 on 2020/06/23.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map1: MKMapView!
    @IBOutlet var lbl_1: UILabel!
    @IBOutlet var lbl_2: UILabel!
    
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let locationManager = CLLocationManager()
        lbl_1.text=""
        lbl_2.text=""
        
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        map1.showsUserLocation = true
    }
    
    

    @IBAction func Location(_ sender: UISegmentedControl) {
        
    }
    
    
}

