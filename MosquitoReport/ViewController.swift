//
//  ViewController.swift
//  MosquitoReport
//
//  Created by Rogério Yokomizo on 2/29/16.
//  Copyright © 2016 Coding for People. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        mapView.addGestureRecognizer(longPressRecognizer)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func longPressed(sender: UILongPressGestureRecognizer)
    {
        if sender.state == UIGestureRecognizerState.Began {
            let touchPoint = sender.locationInView(mapView)
            let newCoordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates

            CLGeocoder().reverseGeocodeLocation(
                CLLocation(latitude: newCoordinates.latitude, longitude:newCoordinates.longitude),
                completionHandler: {(placemarks, error) -> Void in
                    if error != nil {
                        print("Reverse geocoder failed with error" + error!.localizedDescription)
                        return
                    }
                    
                    if placemarks!.count > 0 && placemarks![0].thoroughfare != nil && placemarks![0].subThoroughfare != nil {
                        let pm = placemarks![0]
                        
                        // not all places have thoroughfare & subThoroughfare so validate those values
                        annotation.title = pm.thoroughfare! + ", " + pm.subThoroughfare!
                        annotation.subtitle = pm.subLocality
                        self.mapView.addAnnotation(annotation)
                    }
                    else {
                        annotation.title = "Unknown Place"
                        self.mapView.addAnnotation(annotation)
                    }
                })
        }
    }


}

