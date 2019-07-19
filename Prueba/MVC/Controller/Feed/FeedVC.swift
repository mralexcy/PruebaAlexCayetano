//
//  FeedVC.swift
//  Prueba
//
//  Created by alex on 7/17/19.
//  Copyright © 2019 alex. All rights reserved.
//

import UIKit
import Firebase

import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class FeedVC: UIViewController {
    
    @IBOutlet var objectTableView: UITableView!
    
    var arrayElements = [Feed]()
    var elementSelected:Feed = Feed()
    
    var imageReference: StorageReference {
        return Storage.storage().reference().child("images")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        InitDelegates()
        AddNavigationItem()
    }
    
     // MARK: - Functions
    
    func AddNavigationItem(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Logout", style: .done, target: self, action: #selector(self.actionLogout(sender:)))
    }
    
    @objc func actionLogout(sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            // Close Session
            let sesstion = Session()
            sesstion.getSession()
            
            sesstion.idUser = ""
            sesstion.setSession()
            
            
            // Go to Root VC
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "InitialVC") as! InitialVC
            let navController = UINavigationController.init(rootViewController: vc)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = navController
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllFeeeds()
    }
    
     // MARK: - Requests
    func getAllFeeeds() {
        
        let placeRef = Firestore.firestore().collection("places")
        placeRef.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error \(error!)")
                return
            }
            
            var arrayElementsNew = [Feed]()
            
            for document in snapshot.documents {
                
                let newObject = Feed()
                
                let documentId  = document.documentID
                let createdAt   = document.get("createdAt") as! String
                let description = document.get("description") as! String
                let urlPhoto1   = document.get("urlPhoto1") as! String
                let urlPhoto2   = document.get("urlPhoto2") as! String
                
                newObject.ID = documentId
                newObject.createdAt = createdAt
                newObject.description = description
                newObject.urlPhoto1   = urlPhoto1
                newObject.urlPhoto2   = urlPhoto2
                arrayElementsNew.append(newObject)
            }
            
            self.arrayElements = arrayElementsNew
            self.objectTableView.reloadData()
            
        }
    }
    
    
    // MARK: - Actions
    @IBAction func ActionAddPlace(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "FeedAddVC") as! FeedAddVC
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}


// MARK: - TableView

extension FeedVC : UITableViewDataSource, UITableViewDelegate {
    
    func InitDelegates() {
        objectTableView.delegate = self
        objectTableView.dataSource = self
        objectTableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
        objectTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        objectTableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0);
        
        objectTableView.rowHeight = UITableView.automaticDimension
        objectTableView.estimatedRowHeight = 286
        
        objectTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"FeedCell", for: indexPath) as! FeedCell
        
        let currentFeed:Feed = arrayElements[indexPath.row]
        
        cell.labelDescription.text = currentFeed.description
        cell.labelDate.text        = currentFeed.createdAt
        
        cell.imagePlace.image = UIImage.init(named: "image_empty")
        
        if currentFeed.arrayphotos.count != 0 {
            cell.imagePlace.image = currentFeed.arrayphotos[0]
        } else {
            if currentFeed.urlPhoto1 != "" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.DownloadPhoto(filename: currentFeed.urlPhoto1, numberRow: indexPath.row)
                }
            }
        }
        
        cell.selectionStyle = .none
        
        
        
        return cell
    }
    
    func DownloadPhoto(filename:String, numberRow:Int) {
        
        let downloadImageRef = imageReference.child(filename)
        print(downloadImageRef)
        downloadImageRef.getData(maxSize: 1024*1024*12) { (dataResponse, errorResponse) in
            if let data = dataResponse{
                let image = UIImage(data: data)
                
                let section = 0
                let row = numberRow
                let indexPath = IndexPath(row: row, section: section)
            
                if let cell:FeedCell = self.objectTableView.cellForRow(at: indexPath) as? FeedCell {
                    cell.imagePlace.image = image
                    let currentFeed:Feed = self.arrayElements[row]
                    currentFeed.arrayphotos.append(image!)
                }
                
            }
            
            print(errorResponse ?? "No error")
        }
        
    }
    
    
}
