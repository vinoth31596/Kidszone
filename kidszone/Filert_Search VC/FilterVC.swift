//
//  FilterVC.swift
//  kidszone
//
//  Created by Admin on 6/26/18.
//  Copyright © 2018 iMac. All rights reserved.
//

import UIKit

protocol getBranchDelegate {
    
    func call_Get_Branch(_ km: String, _ rating: String, _ isSelectedID: String)
}

class FilterVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var KMLab: UILabel!
    @IBOutlet weak var slider: VSSlider!
    @IBOutlet weak var liveLabel: UILabel!
    @IBOutlet weak var RatingStartView: FloatRatingView!
    @IBOutlet weak var ratingCard: UIView!
    @IBOutlet weak var colCard: UIView!
    @IBOutlet weak var KMCard: UIView!
    @IBOutlet weak var FilterCollectionView: UICollectionView!
    var get_Branch_Delegate: getBranchDelegate?
    var colFilter: [CollectFilter]? = []
    var isSelect = false
    var rowsWhichAreSelected = [IndexPath]()
    var isSelectedIndex = Int()
    var isSelectedid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingCard.CardView()
        colCard.CardView()
        KMCard.CardView()
        
        FilterCollectionView.register(UINib.init(nibName: "CustomFilterCell", bundle: nil), forCellWithReuseIdentifier: "CustomFilterCell")
        if let flowLayout = FilterCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
            
        }
        RatingStartView.delegate = self
        RatingStartView.contentMode = UIViewContentMode.scaleAspectFit
        RatingStartView.type = .halfRatings
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getFilter()
    }
    
    
    @IBAction func applyFilterACT(_ sender: UIButton) {
        
        if let km = KMLab.text, let rating = liveLabel.text, let selectedid = isSelectedid {
            get_Branch_Delegate?.call_Get_Branch(km, rating, selectedid)
            self.navigationController?.popViewController(animated: true)
        }else {
            get_Branch_Delegate?.call_Get_Branch("", "", "")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func clearFilterACT(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func sliderVaueChanged(_ sender: Any) {
        KMLab.text = String(format: "%.0f", slider.value)
        //KMLab.text = String(slider.value)
    }
    
    
    func getFilter() {
        
        KidZoneServiceHandler.share.callGetAllLKServices { (success, Error) in
            guard let statusCode = success!["status_code"] as? String else { return }
            DispatchQueue.main.async {
                self.colFilter = [CollectFilter]()
                if Int(statusCode) == 200 {
                    if let dataDictionary = success!["data"] as? [String: Any] {
                        if let serviceDic = dataDictionary["services"] as? [[String: Any]] {
                            for serDictionary in serviceDic {
                                let collectFilterValue = CollectFilter()
                                if let id = serDictionary["id"] as? String, let services_green = serDictionary["services_green"] as? String, let name = serDictionary["name"] as? String, let services_white  = serDictionary["services_white"] as? String, let services_log = serDictionary["services_log"] as? String {
                                    
                                    collectFilterValue.id = id
                                    collectFilterValue.name = name
                                    collectFilterValue.services_green = "http://13.126.125.165/kidzone/\(services_green)"
                                    collectFilterValue.services_white = "http://13.126.125.165/kidzone/\(services_white)"
                                    collectFilterValue.services_log = "http://13.126.125.165/kidzone/\(services_log)"
                                }
                                self.colFilter?.append(collectFilterValue)
                            }
                        }
                        self.FilterCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colFilter?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let FRCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomFilterCell", for: indexPath) as? CustomFilterCell
        FRCell?.cardView.card()
        let isRowSelected = rowsWhichAreSelected.contains(indexPath)
        if(isRowSelected == true)
        {
            
        }else{
            
        }
        FRCell?.Fname.text = colFilter![indexPath.row].name
        let imageUrl = colFilter![indexPath.row].services_log!
        FRCell?.Ficons.downloadImage(from: imageUrl)
        return FRCell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let FRCell = self.FilterCollectionView.cellForItem(at: indexPath) as? CustomFilterCell
        if(rowsWhichAreSelected.contains(indexPath) == false) {
            FRCell?.cardView.backgroundColor = UIColor(red: 0.3686, green: 0.7569, blue: 0.5333, alpha: 1.0)
            FRCell?.Fname.textColor = .white
            let imageUrl = colFilter![indexPath.row].services_white!
            FRCell?.Ficons.downloadImage(from:imageUrl)
            rowsWhichAreSelected.append(indexPath)
            print("indexPath:\(indexPath)")
            isSelectedid = colFilter?[indexPath.row].id
        }else{
            
            if let checkedItemIndex = rowsWhichAreSelected.index(of: indexPath){
                FRCell?.cardView.backgroundColor = .white
                FRCell?.Fname.textColor = .black
                let imageUrl = colFilter![indexPath.row].services_log!
                FRCell?.Ficons.downloadImage(from:imageUrl)
                rowsWhichAreSelected.remove(at: checkedItemIndex)
                isSelectedIndex = 0
            }
        }
    }
}
extension FilterVC: FloatRatingViewDelegate {
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        liveLabel.text = String(format: "%.2f", self.RatingStartView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        print(String(format: "%.2f", self.RatingStartView.rating))
    }
    
}
