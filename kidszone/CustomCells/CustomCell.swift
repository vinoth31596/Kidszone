//
//  CustomCell.swift
//  ViewsAdd
//
//  Created by Admin on 6/19/18.
//  Copyright © 2018 xvalue. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell ,UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var deleteBtn: UIButton!
    var myTablController: RegistrationViewController?
    @IBOutlet weak var views: UIView!
    @IBOutlet weak var genderDisplay: UILabel!
    @IBOutlet weak var imageCL: UIImageView!
    @IBOutlet weak var kidsName: RSFloatInputView!
    @IBOutlet weak var dateOfBirth: RSFloatInputView!
    
    
    var imagePicker = UIImagePickerController()
    let picker = UIDatePicker()
    let genderPicker = ["Male","Female"]
    let genPicker = UIPickerView()
    
    @IBOutlet weak var genderSelection: RSFloatInputView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        genderSelection.textField.text = "Male"
        
        kidsName.textField.inputAccessoryView = toolbar
        genderSelection.textField.inputAccessoryView = toolbar
        createDatePicker()
        
        imageCL.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        imageCL.addGestureRecognizer(tapGesture)
        
        genPicker.delegate = self
        genPicker.dataSource = self
        
        genderSelection.textField.inputView = genPicker
        
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderPicker[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        genderSelection.textField.text = genderPicker[row]
        genderSelection.resignFirstResponder()
    }
    
    @objc func doneClicked(){
        views.endEditing(true)
    }
    func createDatePicker(){
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.datePressed))
        toolbar.setItems([flexibleSpace, done], animated: false)
        dateOfBirth.textField.inputAccessoryView = toolbar
        dateOfBirth.textField.inputView = picker
        picker.datePickerMode  = .date
        
    }
    
    @objc func datePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        dateOfBirth.textField.text  = formatter.string(from: picker.date)
        views.endEditing(true)
    }
    
    
    @objc func tapBlurButton(_ sender: UITapGestureRecognizer) {
        print("Please Help!")
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Open the camera
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true, completion: nil)
            //            present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true, completion: nil)
        }
    }
    //MARK: - Choose image from camera roll
    func openGallary() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func deleteRow(_ sender: UIButton) {
        
        myTablController?.deleteCell1(cell: self)
    }
    
    
    @IBAction func genderSelectionPressed(_ sender: Any) {
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension CustomCell:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        /*
         Get the image from the info dictionary.
         If no need to edit the photo, use `UIImagePickerControllerOriginalImage`
         instead of `UIImagePickerControllerEditedImage`
         */
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            //            let indexPath = IndexPath(row: 0, section: 0)
            //            let cell = tabl.cellForRow(at: indexPath) as? CustomCell
            self.imageCL.image = editedImage
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
        print("Cancelled")
    }
    
}


class sliderCell: UITableViewCell {
    
    
    @IBOutlet weak var icons: UIImageView!
    @IBOutlet weak var slideMenuLab: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class filter_Cell: UICollectionViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var Ficons: UIImageView!
    @IBOutlet weak var Fname: UILabel!
    
}

class pro_name_Details_Cell: UICollectionViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var Ficons: UIImageView!
    @IBOutlet weak var Fname: UILabel!
}

class details_cell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var icons: UIImageView!
    @IBOutlet weak var title_name: UILabel!
    @IBOutlet weak var subTitle_name: UILabel!
}

class details_cell1: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var descriptionLab: UILabel!
    @IBOutlet weak var subTitle_name: UILabel!
}
