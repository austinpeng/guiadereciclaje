//
//  SecondViewController.swift
//  La Guia De Estudias
//
//  Created by alden lamp on 1/19/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var moreInfoButton: UIButton!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var subTitleLabel: UILabel!
    
    
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
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        tableView.headerView(forSection: 0)?.backgroundView?.backgroundColor = UIColor.clear
        tableView.headerView(forSection: section)?.textLabel?.textColor = UIColor.white
        
        return "This is a test"
    }
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.titleLabel.text = "taza rojo"
        cell.backgroundColor = UIColor.clear
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "seg", sender: nil)
        //self.navigationController?.pushViewController(SecondViewController(), animated: true)
        
        
    }
    
    
}

