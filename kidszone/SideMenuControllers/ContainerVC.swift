//
//  ViewController.swift
//  Side Menu
//
//  Created by Kyle Lee on 8/6/17.
//  Copyright © 2017 Kyle Lee. All rights reserved.
//

import UIKit

class ContainerVC: UIViewController {
    
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    var sideMenuOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(toggleSideMenu),
                                               name: NSNotification.Name("ToggleSideMenu"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(toggleSideMenuClose),
                                               name: NSNotification.Name("ToggleSideMenuClose"),
                                               object: nil)
    }
    
    @objc func toggleSideMenu() {
        if sideMenuOpen {
            sideMenuOpen = false
            sideMenuConstraint.constant = -280
            
        } else {
            sideMenuOpen = true
            sideMenuConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func toggleSideMenuClose() {
        if sideMenuOpen {
            sideMenuOpen = true
            sideMenuConstraint.constant = -280
            
        } else {
            sideMenuOpen = false
            sideMenuConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    

}

