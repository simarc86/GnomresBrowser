//
//  ViewController.swift
//  GnomesBrowser
//
//  Created by Marc Tamarit Romero on 21/9/18.
//  Copyright © 2018 Marc Tamarit. All rights reserved.
//

import UIKit

struct Towns: Codable {
    let Brastlewark: [Gnome]
}

class ViewController: UIViewController {
    let urlString = "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json"
    var keysSearch: [String] = [SearchKeys.kName, SearchKeys.kAge, SearchKeys.kWeight, SearchKeys.kHairColor, SearchKeys.kProfessions, SearchKeys.kFriends]
    var keyForSearch = SearchKeys.kName
    var gnomes:[Gnome]?
    var filteredGnomes: [Gnome]?
    var dataRetriever = DataRetriever()
    var filter = Filter()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Gnomes"
        
        //Set up tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        //Set up searchBar
        searchBar.delegate = self
        
        //Set up searchPickerView
        searchPickerView.delegate = self
        searchPickerView.dataSource = self
        
        //Fetch data
        dataRetriever.delegate = self
        dataRetriever.retriveDataFrom(urlString: urlString)
        
        //Hide keyboard when scroll
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
    }
}
extension ViewController: DataRetrieverDelegate{
    func dataRetrievedSuccess(gnomes:[Gnome]){
        DispatchQueue.main.async {
            self.gnomes = gnomes
            self.filteredGnomes = self.gnomes
            self.filter.gnomes = self.gnomes
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let gnomes = filteredGnomes else {
            return 0
        }
        return gnomes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gnomeCell", for: indexPath) as! GnomeTableViewCell
        
        if let gnomes = filteredGnomes {
            let gnome = gnomes[indexPath.row]
            cell.nameLbl.text = gnome.name
            cell.ageLbl.text = "\(gnome.age) years"
            cell.imageGnome.loadImageWithUrl(gnome.thumbnail)
        }
        return cell
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredGnomes = filter.getBy(key: keyForSearch, searchText: searchText)
        
        if searchText.isEmpty{
            filteredGnomes = self.gnomes
        }
        
        tableView.reloadData()
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return keysSearch.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return keysSearch[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        keyForSearch = keysSearch[row]
        filteredGnomes = self.gnomes
        refreshKeyboard()
        tableView.reloadData()
    }
    
    func refreshKeyboard(){
        searchBar.endEditing(true)
        self.searchBar.keyboardType =  (KeyboardHandler.requiresDecimal(key: keyForSearch)) ? UIKeyboardType.decimalPad : UIKeyboardType.alphabet
        searchBar.becomeFirstResponder()
    }
}
