//
//  RiderViewController.swift
//  ParseStarterProject
//
//  Created by nasir on 1/1/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation

class RiderViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    var locationManager: CLLocationManager!
    
    var latitude:CLLocationDegrees = 0.0
    
    var longitude: CLLocationDegrees = 0.0
    
    @IBOutlet weak var callUberButton: UIButton!
    
    var riderRequestActive = false
   
    
    @IBAction func callUber(sender: AnyObject) {
        
        
        if riderRequestActive == false {
            
        let riderRequest = PFObject(className:"riderRequest")
        riderRequest["username"] = PFUser.currentUser()!.username
        let point = PFGeoPoint(latitude: latitude, longitude: longitude)
        riderRequest["location"] = point
        riderRequest.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                
                self.callUberButton.setTitle("CANCEL", forState: UIControlState.Normal)
                
            } else {
                let alert = UIAlertController(title: "Something Went Wrong", message: "Please try again", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
            riderRequestActive = true
            
        } else {
            
            self.callUberButton.setTitle("CALL UBER", forState: UIControlState.Normal)
            
            riderRequestActive = false
            
            let query = PFQuery(className:"riderRequest")
            query.whereKey("username", equalTo: PFUser.currentUser()!.username!)
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            object.deleteInBackground()
                        }
                    }
                } else {
                    print(error)
                }
            }
            
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //map.showsUserLocation = true
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location:CLLocationCoordinate2D = manager.location!.coordinate
        
        latitude = location.latitude
        
        longitude = location.longitude
        
        let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.map.setRegion(region, animated: true)
        
        self.map.removeAnnotations(map.annotations)
        
        let pinLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = pinLocation
        dropPin.title = "Your Location"
        map.addAnnotation(dropPin)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        PFUser.logOut()
        
        let currentUser = PFUser.currentUser()
        
    }

}
