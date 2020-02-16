//
//  ViewController.swift
//  022detectABeacon
//
//  Created by Vaughn on 9/16/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        // when user chooses to give access or not, we'll be told because we are the delegate for CLLocationManager
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // did we get authorized?
        if status == . authorizedAlways {
            // is ranging (how far something is from device) available?
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    // uuid = universally unique id - made in terminal with uuidgen
    // UUID - you're in a book store
    // major: you're in the burbank branch (number between 1 and 65535)
    // minor: you're on the second floor in the coffee shop (to subdivide the major number)
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        // sent to location manager to monitor for beacons...
        locationManager?.startMonitoring(for: beaconRegion)
        // and measure the distance between us and the beacon
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    // change the label text and background color to reflect beacon we're scanning for
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"
                
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"
                
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"
                
            default:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
            }
        }
    }
    
    // receive array of beacons, pull out first one and use its proximity property to call update(distance:) and redraw the interface
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }

    @IBOutlet weak var distanceReading: UILabel!
    
}

