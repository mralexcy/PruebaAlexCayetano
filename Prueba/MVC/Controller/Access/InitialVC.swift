//
//  InitialVC.swift
//  Prueba
//
//  Created by alex on 7/17/19.
//  Copyright © 2019 alex. All rights reserved.
//

import UIKit

class InitialVC: UIViewController {
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Prueba"
    }
    

   
    // MARK: - Actions
    @IBAction func ActionGoToLogin(_ sender: UIButton){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    

    @IBAction func ActionGoToRegister(_ sender: UIButton){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    

}
