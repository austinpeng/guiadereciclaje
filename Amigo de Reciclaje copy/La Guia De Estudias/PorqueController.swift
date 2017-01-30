//
//  PorqueController.swift
//  La Guia De Estudias
//
//  Created by alden lamp on 1/25/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit

class PorqueController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var reasoning: UILabel!
    
    @IBOutlet var porqueLabel: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(back(sender:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeDown)
        self.tabBarController?.tabBar.isHidden = true
        
        titleLabel.adjustsFontSizeToFitWidth = true
        reasoning.adjustsFontSizeToFitWidth = true
        porqueLabel.adjustsFontSizeToFitWidth = true
        
        reasoning.alpha = 0.0
        porqueLabel.alpha = 0.0
        
        UIView.animate(withDuration: 2, animations: {
            self.reasoning.alpha = 1.0
            self.porqueLabel.alpha = 1.0
        })
    }
    
    func back(sender: UIBarButtonItem) {
        
        self.tabBarController?.tabBar.isHidden = false
        _ = navigationController?.popViewController(animated: true)
    }


}
