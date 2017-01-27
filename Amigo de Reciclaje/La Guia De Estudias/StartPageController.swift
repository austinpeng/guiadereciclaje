//
//  StartPageController.swift
//  La Guia De Estudias
//
//  Created by alden lamp on 1/26/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit

class StartPageController: UIViewController {

    @IBOutlet var desLabel: UILabel!
    
    @IBOutlet var startButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startButton.alpha = 0.0
        desLabel.alpha = 0.0
        
        startButton.layer.cornerRadius = 16
        startButton.layer.masksToBounds = true
        startButton.layer.borderColor = UIColor.white.cgColor
        startButton.layer.borderWidth = 1.5
        
        UIView.animate(withDuration: 2, animations: {
            
            self.startButton.alpha = 1
            self.desLabel.alpha = 1
            
        })
        
    }

    
}
