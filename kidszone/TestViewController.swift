//
//  TestViewController.swift
//  kidszone
//
//  Created by Admin on 7/6/18.
//  Copyright © 2018 iMac. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let  detail_working_days1 = "{\"Mon\":[\" 6:30 am- 6:30 pm\"],\"Tue\":[\" 6:30 am- 6:30 pm\"],\"Wed\":[\" 6:30 am- 6:30 pm\"],\"Thu\":[\" 6:30 am- 6:30 pm\"],\"Fri\":[\" 6:30 am- 6:30 pm\"],\"Sat\":[\"Holiday\"],\"Sun\":[\"Holiday\"]}"
        
        let str_arr = detail_working_days1.components(separatedBy: ",")
        for arr in 0..<str_arr.count {
            let brace = str_arr[arr].replacingOccurrences(of: "{", with: " ")
            let brace1 = brace.replacingOccurrences(of: "}", with: " ")
            let leftBraget = brace1.replacingOccurrences(of: "[", with: " ")
            let rightBraget = leftBraget.replacingOccurrences(of: "]", with: " ")
            print(rightBraget)
        }
    }
}
