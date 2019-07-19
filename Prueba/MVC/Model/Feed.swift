//
//  Feed.swift
//  Prueba
//
//  Created by DLWPRO on 7/18/19.
//  Copyright © 2019 alex. All rights reserved.
//

import UIKit

class Feed {
    var ID: String
    var description: String
    var createdAt: String
    var urlPhoto1: String
    var urlPhoto2: String
    
    var arrayphotos = [UIImage]()
    
    init() {
        self.ID          = ""
        self.description = ""
        self.createdAt   = ""
        self.urlPhoto1   = ""
        self.urlPhoto2   = ""
        self.arrayphotos = [UIImage]()
    }
    
    
    func getDict() -> [String: Any] {
        let dict:[String: Any] = [
            "createdAt":   self.createdAt,
            "description": self.description,
            "urlPhoto1":   self.urlPhoto1,
            "urlPhoto2":   self.urlPhoto2
        ]
        return dict
    }
    
    
}
