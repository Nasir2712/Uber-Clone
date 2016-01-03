//
//  RequestViewController.swift
//  ParseStarterProject
//
//  Created by nasir on 1/2/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import MapKit
import Parse

class RequestViewController: UIViewController, CLLocationManagerDelegate {
    
    var requestLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var requestUsername: String = ""
    

    @IBAction func pickUpRider(sender: AnyObject) {
        
        let query = PFQuery(className:"riderRequest")
        query.whereKey("username", equalTo: requestUsername)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        
                        object["driverResponded"] = PFUser.currentUser()!.username!
                        
                        let query = PFQuery(className:"riderRequest")
                        
                        query.getObjectInBackgroundWithId(object.objectId!) {
                            
                            (object: PFObject?, error: NSError?) -> Void in
                            if error != nil {
                                
                                print(error)
                                
                            } else if let object = object {
                              
                                object["driverResponded"] = PFUser.currentUser()!.username!
                                    
                                object.saveInBackground()
                                
                                let requestCLLocation = CLLocation(latitude: self.requestLocation.latitude, longitude: self.requestLocation.longitude)
                                
                                CLGeocoder().reverseGeocodeLocation(requestCLLocation, completionHandler: { (placemarks,  error) -> Void in
                                    
                                    if error != nil {
                                        
                                        print(error)
                                        
                                    } else {
                                        
                                        if placemarks!.count > 0 {
                                            
                                            let pm = placemarks![0] as! CLPlacemark
                                            
                                            let mkPm = MKPlacemark(placemark: pm)
                                            
                                            let mapItem = MKMapItem(placemark: mkPm)
                                            
                                            mapItem.name = self.requestUsername
                                            
                                            let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                                            
                                            mapItem.openInMapsWithLaunchOptions(launchOptions)
                                            
                                        } else {
                                            
                                            print("Problem with the data recieved from geocoder")
                                            
                                        }
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                    
                                    
                                    
                                })
                                
                                
                            }
                        }
                        
                        
                    }
                }
                
            } else {
                
                print(error)
            }
        }
        
    }
    

    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let region = MKCoordinateRegion(center: requestLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.map.setRegion(region, animated: true)
        
        self.map.removeAnnotations(map.annotations)
        
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = requestLocation
        dropPin.title = requestUsername
        map.addAnnotation(dropPin)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
