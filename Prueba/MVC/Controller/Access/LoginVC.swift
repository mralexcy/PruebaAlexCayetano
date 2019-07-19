//
//  LoginVC.swift
//  Prueba
//
//  Created by alex on 7/17/19.
//  Copyright © 2019 alex. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    @IBOutlet var textEmail: UITextField!
    @IBOutlet var textPass: UITextField!
    
    @IBOutlet var buttonLogin: UIButton!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Login"
        
        SetupDelegatesTextField()
    }
    

    // MARK: - Actions
    @IBAction func ActionLogin(_ sender: UIButton) {
        
        let email = textEmail.text!
        let password  = textPass.text!
     
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard let strongSelf = self else { return }
            
             if user != nil { // Success
                
                 // Start Session
                let sesstion = Session()
                sesstion.getSession()
                
                sesstion.idUser = email
                sesstion.setSession()
                
                // Go To Feed
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = mainStoryBoard.instantiateViewController(withIdentifier: "FeedVC") as! FeedVC
                let navController = UINavigationController.init(rootViewController: vc)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = navController
                
            }
            
            if user == nil {// Error
                let uiAlert = UIAlertController(title: "Prueba", message: "El Usuario No Existe", preferredStyle: UIAlertController.Style.alert)
                self!.present(uiAlert, animated: true, completion: nil)
                uiAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            }
            
        }
        
        
    }
    

}



// MARK: - Textfield

extension LoginVC : UITextFieldDelegate {
    
    func SetupDelegatesTextField(){
        hideKeyboardWhenTappedAround()
        textEmail.delegate = self
        textEmail.returnKeyType = UIReturnKeyType.done
        
        textPass.delegate = self
        textPass.returnKeyType = UIReturnKeyType.done
        
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
