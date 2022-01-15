//
//  AboutViewController.swift
//  kidszone
//
//  Created by iMac on 28/06/18.
//  Copyright © 2018 iMac. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
var hideMenuDelegate: HideSideMenu?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissVC(_ sender: UIBarButtonItem) {
        hideMenuDelegate?.hideMenu(true)
        self.dismiss(animated: true, completion: nil)
    }
}
