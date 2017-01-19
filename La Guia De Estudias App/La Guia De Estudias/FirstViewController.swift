//
//  FirstViewController.swift
//  La Guia De Estudias
//
//  Created by alden lamp on 1/19/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit
import MapKit

class FirstViewController: UIViewController {

    
    @IBOutlet var map: MKMapView!
    
    @IBOutlet var containterView: UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let location = CLLocationCoordinate2D(latitude: 40.724706, longitude: -74.308496)
        let region = MKCoordinateRegionMake(location, span)
        
        map.setRegion(region, animated: true)
        
        var annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "RECYCLING Bin Here"
        
        var annotation2 = CustomPointAnnotation()
        annotation2.imageName = "recycle-can-hi.png"
        annotation2.title = "TEST"
        annotation2.coordinate = location
        
        
        map.addAnnotation(annotation2)
        
    }
    
    class CustomPointAnnotation: MKPointAnnotation {
        var imageName: String!
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.canShowCallout = true
        }
        else {
            anView?.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as! CustomPointAnnotation
        anView?.image = UIImage(named:cpa.imageName)
        
        return anView
    }
    
    
}

