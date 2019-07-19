//
//  FeedAddVC.swift
//  Prueba
//
//  Created by alex on 7/17/19.
//  Copyright © 2019 alex. All rights reserved.
//

import UIKit

import FirebaseCore
import FirebaseFirestore

import FirebaseStorage

import Photos

import SVProgressHUD

class FeedAddVC: UIViewController {
    
    @IBOutlet var textDescription: UITextField!
    @IBOutlet var imgViewPhoto1: UIImageView!
    @IBOutlet var imgViewPhoto2: UIImageView!
    
    var db: Firestore!
    
    var imageReference: StorageReference {
        return Storage.storage().reference().child("images")
    }
    
    var imagePicker = UIImagePickerController()
    

    var isCurrentNumberSelectedPhoto = 1;
    
    var localFeed:Feed = Feed()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Place"
        SetupDelegatesTextField()
    }
    
    
     // MARK: - Functions
    func GenerateDate() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    
    func GenerateDateShort() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    
    
    func AlertPhotoGenerate(numberPhoto:Int){
        isCurrentNumberSelectedPhoto = numberPhoto
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.modalPresentationStyle = .popover
        
        
        let image1 = UIImage(named: "ico_gallery")
        let imageView1 = UIImageView()
        imageView1.image = image1
        alert.view.addSubview(imageView1)
        imageView1.frame = CGRect(x: 25, y: 18, width: 24, height: 24)
        
        
        let alert1 = UIAlertAction(title: "Foto y Librería de Videos", style: .default){
            action in
            
            self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.imagePicker.allowsEditing = false
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }
        
        let alert2 = UIAlertAction(title: "Cancel", style: .cancel){
            action in
            
        }
        
        alert.addAction(alert1)
        alert.addAction(alert2)
        
        alert.view.tintColor = UIColor.black
        
        present(alert, animated: true, completion: nil)
        
    }
 
    
    // MARK: - Actions
    @IBAction func ActionAddPhoto1(_ sender: UIButton) {
        AlertPhotoGenerate(numberPhoto: 1)
    }
    
    @IBAction func ActionAddPhoto2(_ sender: UIButton) {
        AlertPhotoGenerate(numberPhoto: 2)
    }
    
    @IBAction func ActionAddFeed(_ sender: UIButton){
        SendDataFeedFirestore()
    }
    
    
    func SendDataFeedFirestore(){
        
        SVProgressHUD.show()
        
        let descriptionContent = textDescription.text!
        
        let currentDateStr = GenerateDate() // Get Date
        
        // Setting Local Feedd
        localFeed.createdAt = currentDateStr
        localFeed.description = descriptionContent
        localFeed.urlPhoto1   = ""
        localFeed.urlPhoto2   = ""
        
        // Create Document
        db = Firestore.firestore()
        
        var ref: DocumentReference? = nil
        ref = db.collection("places").addDocument(data: localFeed.getDict()) { err in
            if let err = err {
                SVProgressHUD.dismiss()
                print("Error adding document: \(err)")
            } else {
                let idDocument = ref!.documentID
                self.localFeed.ID = idDocument
                self.LogicUploadPhotos()
            }
        }
        
    }
    
    func LogicUploadPhotos(){
        
       let uploadImage1 = imgViewPhoto1.image
       let uploadImage2 = imgViewPhoto2.image
        
       // First Block
        
        if uploadImage1 != nil {
          
            UploadPhoto(image: uploadImage1!) { result, namePhoto in
                
                if result == true {
                    self.localFeed.urlPhoto1 = namePhoto
                    self.UpdateDatabase()
                }
                
                // Inside Second Block
                if uploadImage2 != nil {
                    
                    self.UploadPhoto(image: uploadImage2!) { result, namePhoto in
                        
                        if result == true {
                            self.localFeed.urlPhoto2 = namePhoto
                            self.UpdateDatabase()
                        }
                        SVProgressHUD.dismiss()
                        
                        let uiAlert = UIAlertController(title: "Prueba", message: "Success", preferredStyle: UIAlertController.Style.alert)
                        self.present(uiAlert, animated: true, completion: nil)
                        uiAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {_ in
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        }))
                        
                        
                    }
                    
                } else {
                    SVProgressHUD.dismiss()
                    let uiAlert = UIAlertController(title: "Prueba", message: "Success", preferredStyle: UIAlertController.Style.alert)
                    self.present(uiAlert, animated: true, completion: nil)
                    uiAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {_ in
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    }))
                }
                
                
            }
            
        } else {
            
            // Inside Third Block
            if uploadImage2 != nil {
                
                self.UploadPhoto(image: uploadImage2!) { result, namePhoto in
                    
                    if result == true {
                        self.localFeed.urlPhoto2 = namePhoto
                        self.UpdateDatabase()
                    }
                    SVProgressHUD.dismiss()
                    let uiAlert = UIAlertController(title: "Prueba", message: "Success", preferredStyle: UIAlertController.Style.alert)
                    self.present(uiAlert, animated: true, completion: nil)
                    uiAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {_ in
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    }))
                    
                    
                }
                
            } else {
                SVProgressHUD.dismiss()
                let uiAlert = UIAlertController(title: "Prueba", message: "Success", preferredStyle: UIAlertController.Style.alert)
                self.present(uiAlert, animated: true, completion: nil)
                uiAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {_ in
                    
                    self.navigationController?.popViewController(animated: true)
                    
                }))
                
            }
            
        }
        
        
    }
    
    func UpdateDatabase(){
        db.collection("places").document(localFeed.ID).setData(localFeed.getDict())
    }
    
    func UploadPhoto(image:UIImage?, completion: @escaping (Bool, String) ->())
    {
        
        var namePhoto1 = ""
        let uploadImage1 = image
        
        if uploadImage1 != nil {
            
            let date1Short = GenerateDateShort()
            let nameId = localFeed.ID
            let filename1 = "\(nameId)_\(date1Short)"
            
            let image1 = uploadImage1
            guard let imageData = image1!.jpegData(compressionQuality: 0.3) else { return }
            
            let uploadImageRef = imageReference.child(filename1)
            
            let uploadTask = uploadImageRef.putData(imageData, metadata: nil) { (metadata, error) in
                print("UPLOAD TASK FINISHED")
                print(metadata ?? "NO METADATA")
                print(error ?? "NO ERROR")
                
                if error == nil{
                    namePhoto1 = metadata?.name ?? ""
                    completion(true, namePhoto1)
                } else {
                    completion(false, "")
                }
                
            }
            
            uploadTask.observe(.progress) { (snapshot) in
                print(snapshot.progress ?? "NO MORE PROGRESS")
            }
            
            uploadTask.resume()
            
        }
        
        
    }
    
    

}

//MARK: - UIImagePickerControllerDelegate
extension FeedAddVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
           let profileImage = editedImage
         
           if self.isCurrentNumberSelectedPhoto == 1 {
               self.imgViewPhoto1.image = profileImage
            }
            
           if self.isCurrentNumberSelectedPhoto == 2 {
                self.imgViewPhoto2.image = profileImage
            }
            
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - Textfield
extension FeedAddVC : UITextFieldDelegate {
    
    func SetupDelegatesTextField(){
        hideKeyboardWhenTappedAround()
        textDescription.delegate = self
        textDescription.returnKeyType = UIReturnKeyType.done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
}
