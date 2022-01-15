//
//  SignUpSliderVC.swift
//  kidszone
//
//  Created by Admin on 6/29/18.
//  Copyright © 2018 iMac. All rights reserved.
//

import UIKit

class SignUpSliderVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var kzScroll: UIScrollView!
    @IBOutlet weak var kzPageControl: UIPageControl!
    @IBOutlet weak var kzImage: UIImageView!
    var doneBtn = UIButton()
    var contentWidth: CGFloat = 0.0
    var kzSlider_Arr = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDoneBtn()
        doneBtn.isHidden = true
        kzSlider_Arr = ["pro_1", "pro_2", "pro_3", "pro_4", "pro_5"]
        kzPageControl.numberOfPages = kzSlider_Arr.count
        kzScroll.delegate = self
        for image in 0..<kzSlider_Arr.count {
            
            let imageToDisplay = UIImage(named: "\(kzSlider_Arr[image])")
            let imageview = UIImageView(image: imageToDisplay)
            imageview.contentMode = .scaleToFill
            let xPossition = self.view.frame.width * CGFloat(image)
            contentWidth += view.frame.width
            imageview.frame = CGRect(x: xPossition, y: 0, width: view.frame.width, height: view.frame.height-100)
            kzScroll.contentSize.width = kzScroll.frame.width * CGFloat(image + 1)
            kzScroll.addSubview(imageview)
            
        }
        
        kzScroll.contentSize = CGSize(width: contentWidth, height: view.frame.height - 100)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        kzPageControl.currentPage = Int(kzScroll.contentOffset.x / CGFloat(self.kzScroll.frame.width))
        if kzPageControl.currentPage == 4 {
            doneBtn.isHidden = false
        }else {
            doneBtn.isHidden = true
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("End....")
    }
   
    fileprivate func setupDoneBtn() {
        
        doneBtn = UIButton(type: .system)
        doneBtn.frame = CGRect(x: self.view.frame.width - 90, y: self.view.frame.size.height - 35, width: 50, height: 25)
        doneBtn.setTitle("Done", for: .normal)
        doneBtn.setTitleColor(.red, for: .normal)
        doneBtn.addTarget(self, action: #selector(doneACT), for: .touchUpInside)
        self.view.addSubview(doneBtn)
    }
    
    @objc func doneACT(sender: UIButton!) {
        
        let containerVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:
        "ContainerVC") as? ContainerVC
        self.navigationController?.present(containerVC!, animated: true, completion: nil)
    }
}
