//
//  ViewController.swift
//  La Guia De Estudias
//
//  Created by alden lamp on 1/24/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var backgroundImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(back(sender:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeDown)
        self.tabBarController?.tabBar.isHidden = true
        
        titleLabel.adjustsFontSizeToFitWidth = true
        
        backgroundImage.layer.zPosition = -1
        
        titleLabel.text = currentItem
        descriptionLabel.text = currentdescription
        imageView.image = currentImage
        
        
    }
    
    func rd(des : String, title : String, image : UIImage){
        reloadData(des: des, title: title, image: image)
    }
    
    func reloadData (des : String, title : String, image : UIImage){
        
        print(title)
        var a = title
        self.titleLabel.text = "testing"
        self.descriptionLabel.text = "\(des)"
        self.imageView.image = image
    }
    
    func back(sender: UIBarButtonItem) {
        self.tabBarController?.tabBar.isHidden = false
        _ = navigationController?.popViewController(animated: true)
    }
    
    
}
