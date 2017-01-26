//
//  ViewController.swift
//  La Guia De Estudias
//
//  Created by alden lamp on 1/24/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(back(sender:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeDown)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        print("test")
        self.tabBarController?.tabBar.isHidden = false
        _ = navigationController?.popViewController(animated: true)
    }
    
    
}
