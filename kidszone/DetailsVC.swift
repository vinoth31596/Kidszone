//
//  DetailsVC.swift
//  kidszone
//
//  Created by Admin on 7/5/18.
//  Copyright © 2018 iMac. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var details_tbl: UITableView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var detail_subTitle: UILabel!
    @IBOutlet weak var detail_title: UILabel!
    @IBOutlet weak var icons: UIImageView!
    @IBOutlet weak var select_user_profile: UIImageView!
    @IBOutlet weak var select_title_name: UILabel!
    @IBOutlet weak var selet_address: UITextView!
    var navbar : UINavigationBar!
    @IBOutlet weak var TextView: UIView!
    @IBOutlet weak var TabName: UILabel!
    
    var title_name: String?
    var address: String?
    var profile: UIImage?
    var detail_tl: String?
    var detail_ST: String?
    var detail_icon: UIImage?
    var detail_description: String?
    var detail_photo_url: String?
    var detail_working_days: String?
    var number: String?
    var contentWidth: CGFloat = 0.0
    
    var kzSlider_Arr = [String]()
    var workDay_arr = [String]()
    lazy var scrollciew: UIScrollView = {
        
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize.height = 150
        //view.backgroundColor = .brown
        
        return view
    
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.sizeToFit()
         print("NavigationBar Frame : \(String(describing: self.navigationController!.navigationBar.frame))")
         kzSlider_Arr = ["pro_1", "pro_2", "pro_3", "pro_4", "pro_5"]
        select_title_name.text = title_name
        selet_address.text = address
        TabName.text = title_name
//        detail_title.text = detail_tl
//        detail_subTitle.text = detail_ST
//        icons.image = detail_icon
        details_tbl.estimatedRowHeight = details_tbl.rowHeight
        details_tbl.rowHeight = UITableViewAutomaticDimension

    }
    
    //Hide Statusbar
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(false)
        
        //Important!
        if #available(iOS 11.0, *) {
            
            //Default NavigationBar Height is 44. Custom NavigationBar Height is 66. So We should set additionalSafeAreaInsets to 66-44 = 22
            self.additionalSafeAreaInsets.top = 0
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 1 {
            return 150
        }
        
        return self.details_tbl.rowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let details_cell = tableView.dequeueReusableCell(withIdentifier: "details_cell1", for: indexPath) as! details_cell1
        details_cell.cardView.shadowView(color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        if indexPath.row == 0 {
            if let descripStr = detail_description {
                details_cell.descriptionLab.text = descripStr
            }else {
                details_cell.descriptionLab.text = "Kidzone – Kids learning center is a multi-page web design which suit for any type of schools such as learning center, kindergarten, primary, secondary, high school and universities.Kidzone – Kids learning center is a multi-page web design which suit for any type of schools such as learning center, kindergarten, primary, secondary, high school and universities."
            }
            
        }else if indexPath.row == 1 {
            
            details_cell.cardView.frame = CGRect()
            
            //details_cell.descriptionLab.text = "Not found any images."
            
            details_cell.addSubview(scrollciew)
            scrollciew.topAnchor.constraint(equalTo: details_cell.cardView.topAnchor).isActive = true
            scrollciew.bottomAnchor.constraint(equalTo: details_cell.cardView.bottomAnchor).isActive = true
            scrollciew.leftAnchor.constraint(equalTo: details_cell.cardView.leftAnchor).isActive = true
            scrollciew.rightAnchor.constraint(equalTo: details_cell.cardView.rightAnchor).isActive = true
            scrollciew.alwaysBounceHorizontal = true
            scrollciew.isDirectionalLockEnabled = true
            scrollciew.isPagingEnabled = true
            
            for image in 0..<kzSlider_Arr.count {
                
                let imageToDisplay = UIImage(named: "\(kzSlider_Arr[image])")
                let imageview = UIImageView(image: imageToDisplay)
                imageview.contentMode = .scaleToFill
                imageview.clipsToBounds = true
                imageview.layer.cornerRadius = 5
                imageview.layer.shadowColor = UIColor.lightGray.cgColor
                imageview.layer.opacity = 1
                imageview.layer.shadowOffset = CGSize(width: -1, height: 1)
                imageview.layer.shadowRadius = 3
                let xPossition = ((details_cell.contentView.frame.width) - 290) * CGFloat(image)
                contentWidth += details_cell.contentView.frame.width - 275
                imageview.frame = CGRect(x: xPossition + 10, y: 20, width: details_cell.contentView.frame.width - 295, height: details_cell.contentView.frame.height - 50)
                scrollciew.contentSize.width = ((details_cell.contentView.frame.width) - 295) * CGFloat(image + 1)
                scrollciew.addSubview(imageview)
                
            }
            
             scrollciew.contentSize = CGSize(width: contentWidth, height: details_cell.contentView.frame.height - 30)
            
        }else if indexPath.row == 2 {
            
            details_cell.descriptionLab.text = "Business Hours \n Monday \n Tuesday \n Wednesday \n Thursday \n Friday \n Saturday \n Sunday"
//            let str_arr = detail_working_days?.components(separatedBy: ",")
//            if let str = str_arr {
//                if (str.count) > 6 {
//                    let firstOne = str_arr![0]
//                    let secondOne = str_arr![1]
//                    let thirdOne = str_arr![2]
//                    let fouthOne = str_arr![3]
//                    let fifthOne = str_arr![4]
//                    let sixthOne = str_arr![5]
//                    let seventhOne = str_arr![6]
//
//                    details_cell.descriptionLab.text = "\(firstOne) \n\(secondOne) \n\(thirdOne) \n\(fouthOne) \n\(fifthOne) \n\(sixthOne) \n\(seventhOne)"
//                }
//            }
            
            if let bussiness_hour = detail_working_days {
                let data = bussiness_hour.data(using: .utf8)!
                
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String: Any] {
                        
                        if let monday = jsonArray["Mon"] ,let tueday = jsonArray["Tue"], let weday = jsonArray["Wed"], let thuday = jsonArray["Thu"], let friday = jsonArray["Fri"], let satday = jsonArray["Sat"], let sunday = jsonArray["Sun"]  {
                            var leftparenthesis = String()
                            leftparenthesis = "Mon:\(monday) \nTue:\(tueday) \nWed:\(weday) \nThu:\(thuday) \nFri:\(friday) \nSat:\(satday) \nSun:\(sunday)"
                            let leftstr = leftparenthesis.replacingOccurrences(of: "(", with: "")
                            let rightstr = leftstr.replacingOccurrences(of: ")", with: "")
                            details_cell.descriptionLab.text = rightstr
                        }
                        
                        
                    } else {
                        print("bad json")
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        
        return details_cell
    }
    @IBAction func BtnACT(_ sender: UIButton) {
        
        if sender.tag == 1 { // Call Action
            
            guard let number = URL(string: "tel://" + self.number!) else { return }
            UIApplication.shared.open(number)
            
        }else { // Chat Action
            
            let chatVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyChatViewController") as? MyChatViewController
            self.navigationController?.pushViewController(chatVC!, animated: true)
        }
    }
}
