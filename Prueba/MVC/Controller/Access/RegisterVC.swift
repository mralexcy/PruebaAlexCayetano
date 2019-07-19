//
//  RegisterVC.swift
//  Prueba
//
//  Created by alex on 7/17/19.
//  Copyright © 2019 alex. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {

    @IBOutlet var textEmail: UITextField!
    @IBOutlet var textPassword: UITextField!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Register"
        
        SetupDelegatesTextField()
        
    }
    
    // MARK: - Actions
    @IBAction func ActionRegister(_ sender: UIButton){
        
        let email    = textEmail.text!
        let password = textPassword.text!
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if authResult != nil {
                let uiAlert = UIAlertController(title: "Prueba", message: "Register Successful", preferredStyle: UIAlertController.Style.alert)
                self.present(uiAlert, animated: true, completion: nil)
                uiAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler:{_ in
                    self.navigationController?.popViewController(animated: true)
                }))
            }
            
            if authResult == nil {
                let uiAlert = UIAlertController(title: "Prueba", message: "Could not register, try again", preferredStyle: UIAlertController.Style.alert)
                self.present(uiAlert, animated: true, completion: nil)
                uiAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler:nil))
            }
            
            
        }
    }

}

// MARK: - Textfield

extension RegisterVC : UITextFieldDelegate {
    
    func SetupDelegatesTextField(){
        hideKeyboardWhenTappedAround()
        textEmail.delegate = self
        textEmail.returnKeyType = UIReturnKeyType.done
        
        textPassword.delegate = self
        textPassword.returnKeyType = UIReturnKeyType.done
        
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
