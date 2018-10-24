//
//  ProfessionsTableViewController.swift
//  GnomesBrowser
//
//  Created by Marc Tamarit Romero on 26/9/18.
//  Copyright © 2018 Marc Tamarit. All rights reserved.
//

import UIKit

class ProfessionsTableViewController: UITableViewController {
    var professions: [String]!

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return professions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfessionCell")!
        
        let profession = self.professions[indexPath.row]
        cell.textLabel?.text = profession
        return cell
    }
}
