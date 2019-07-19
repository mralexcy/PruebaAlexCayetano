//
//  FeedCell.swift
//  Prueba
//
//  Created by DLWPRO on 7/18/19.
//  Copyright © 2019 alex. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet var imagePlace: UIImageView!
    @IBOutlet var labelDescription: UILabel!
    @IBOutlet var labelDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
