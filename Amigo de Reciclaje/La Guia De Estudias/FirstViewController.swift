//
//  FirstViewController.swift
//  La Guia De Estudias
//
//  Created by alden lamp on 1/19/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

class FirstViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet var map: MKMapView!
    
    @IBOutlet var containterView: UIView!
    
    @IBOutlet var PlaceTitleLabel: UILabel!
    @IBOutlet var placeDescriptionLabel: UILabel!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    var name = [String]()
    var descriptions = [String]()
    var image = [UIImage]()
    var fullNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containterView.isHidden = true
        
        titleLabel.sizeToFit()
        titleLabel.adjustsFontSizeToFitWidth = true
        PlaceTitleLabel.adjustsFontSizeToFitWidth = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 16
        
        
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let location = CLLocationCoordinate2D(latitude: 40.824706, longitude: -74.308496)
        let region = MKCoordinateRegionMake(location, span)
        
        map.setRegion(region, animated: true)
        map.layer.cornerRadius = 16
        
        getData()
    }
    
    
    
    func getData(){
        var placeName = [String]()
        var lat = [Double]()
        var long = [Double]()
        var description = [String]()
        var fullName = [String]()
        var imageArr = [UIImage]()
        
        let path = Bundle.main.path(forResource: "info", ofType: "json")!
        let data = NSData(contentsOfFile: path) as NSData!
        let json = JSON(data: data as! Data, error : nil)
        
        
        var it = json["places"].makeIterator()
        while let stuff = it.next(){
            
            placeName.append(stuff.0)
            let miniJson = stuff.1
            lat.append(miniJson["lat"].double!)
            long.append(miniJson["long"].double!)
            description.append(miniJson["description"].string!)
            fullName.append(miniJson["name"].string!)
            
            
            let imageName = miniJson["image"].string!
            let image1 = UIImage(named: "\(imageName)")
            imageArr.append(image1!)
        }
        
        self.image = imageArr
        self.descriptions = description
        self.name = placeName
        self.fullNames = fullName
        putAnnotations(name: placeName, lat: lat, long: long)
    }
    
    func putAnnotations(name : [String], lat : [Double], long : [Double]){      //, images : [UIImage]){
        
        for i in 0...name.count-1{
        
            let location = CLLocationCoordinate2D(latitude: lat[i], longitude: long[i])
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = name[i]
            map.addAnnotation(annotation)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        containterView.isHidden = false
        var indexNum = name.index(of: view.annotation?.title! as String!)!
        PlaceTitleLabel.text = fullNames[indexNum]
        placeDescriptionLabel.text = descriptions[indexNum]
        imageView.image = image[indexNum]
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
}

