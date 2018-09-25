//
//  GnomeTableViewCell.swift
//  GnomesBrowser
//
//  Created by Marc Tamarit Romero on 21/9/18.
//  Copyright © 2018 Marc Tamarit. All rights reserved.
//

import UIKit

class GnomeTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var imageGnome: ImageCached!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
