//
//  SecondViewController.swift
//  La Guia De Estudias
//
//  Created by alden lamp on 1/19/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit
import SwiftyJSON


var currentItem = String()
var currentImage = UIImage()
var currentdescription = String()



class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var moreInfoButton: UIButton!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var subTitleLabel: UILabel!
    
    
    var items = [String]()
    var works = [Bool]()
    var images = [UIImage]()
    var descriptions = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moreInfoButton.layer.borderColor = UIColor.white.cgColor
        moreInfoButton.layer.cornerRadius = 16
        moreInfoButton.layer.borderWidth = 1.5
        moreInfoButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        titleLabel.adjustsFontSizeToFitWidth = true
        subTitleLabel.adjustsFontSizeToFitWidth = true
        tableView.backgroundColor = UIColor.clear
        
        self.tabBarController?.tabBar.isHidden = false
        
        
        getData()
    }
    
    
    func getData(){
        let path = Bundle.main.path(forResource: "info", ofType: "json")!
        let data = NSData(contentsOfFile: path) as NSData!
        let json = JSON(data: data as! Data, error : nil)
        
        
        var it = json["recycling items"].makeIterator()
        
        while let miniJson = it.next(){
            items.append(miniJson.0)
            works.append((miniJson.1["recycle"].bool)!)
            images.append(UIImage(named: miniJson.1["image"].string!)!)
            descriptions.append(miniJson.1["description"].string!)
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.titleLabel.text = items[indexPath.row]
        cell.titleLabel.adjustsFontSizeToFitWidth = true
        cell.iconImage.image = images[indexPath.row]
        cell.symbolImage.image = UIImage(named: works[indexPath.row] ? "checkmark" : "delete_sign")
        
        cell.backgroundColor = UIColor.clear
        cell.selectedBackgroundView?.backgroundColor = UIColor.clear
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        currentItem = items[indexPath .row]
        currentImage = images[indexPath.row]
        currentdescription = descriptions[indexPath.row]
        performSegue(withIdentifier: "seg", sender: nil)
        
    }
    
    
}

