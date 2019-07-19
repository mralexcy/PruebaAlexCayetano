//
//  Session.swift
//  Distriluz
//
//  Created by Alexander Arturo Cayetano Yaya on 19/10/18.
//  Copyright © 2018 Delaware Consultoría. All rights reserved.
//

import UIKit

class Session: NSObject {

    var idUser:String          = ""
    
    func setSession(){
        let defaults = UserDefaults.standard
        defaults.set(self.idUser, forKey: "sessionIdUser")
    }
    
    func getSession(){
        let defaults = UserDefaults.standard
        self.idUser      = defaults.string(forKey: "sessionIdUser") ?? ""
    }
   
    

}
