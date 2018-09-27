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
    @IBOutlet weak var profileFGImgeView: ImageCached!
    @IBOutlet weak var profileContainerImageView: ImageCached!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var hairColorLabel: UILabel!
    @IBOutlet var idNumberLabel: UILabel!
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var professionsTableView: UITableView!
    
    let professionsTableViewController = ProfessionsTableViewController()
    
    var friends: [String] = []{
        didSet{
            friendsTableView.reloadData()
        }
    }
    
    var professions: [String] = []{
        didSet{
            professionsTableViewController.professions = professions
            professionsTableView.delegate = professionsTableViewController
            professionsTableView.dataSource = professionsTableViewController
            professionsTableView.reloadData()
        }
    }
    
    var weight: Double = 0.0{
        didSet{
            weightLabel.text = (String(format: "%.2f", weight))
        }
    }
    
    var height: Double = 0.0{
        didSet{
            heightLabel.text = (String(format: "%.2f", height))
        }
    }
    
    var age: Int = 0{
        didSet{
            ageLabel.text = String(age)
        }
    }
    
    var number: Int = 0 {
        didSet {
            idNumberLabel.text = String(number)
            //openNumberLabel.text = String(number)
        }
    }

    var hairColor: String = ""{
        didSet {
            hairColorLabel.text = hairColor
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
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
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

extension GnomeFoldingTableViewCell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell")!

        let friend = self.friends[indexPath.row]
        cell.textLabel?.text = friend
        return cell
    }
}
