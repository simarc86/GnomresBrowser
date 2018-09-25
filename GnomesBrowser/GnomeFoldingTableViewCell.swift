//
//  GnomeFoldingTableViewCell.swift
//  GnomesBrowser
//
//  Created by Marc Tamarit Romero on 25/9/18.
//  Copyright © 2018 Marc Tamarit. All rights reserved.
//

import UIKit
import FoldingCell

class GnomeFoldingTableViewCell: FoldingCell {

    @IBOutlet weak var nameFG: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileImageView: ImageCached!

    @IBOutlet var idNumberLabel: UILabel!
    @IBOutlet var openNumberLabel: UILabel!
    
    var number: Int = 0 {
        didSet {
            idNumberLabel.text = String(number)
            openNumberLabel.text = String(number)
        }
    }
    
    var nameGnome: String = ""{
        didSet {
            name.text = nameGnome
            nameFG.text = nameGnome
        }
    }
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
}

extension GnomeFoldingTableViewCell{
    @IBAction func buttonHandler(_: AnyObject) {
        print("tap")
    }
}
