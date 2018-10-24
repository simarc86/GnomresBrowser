//
//  ViewController.swift
//  GnomesBrowser
//
//  Created by Marc Tamarit Romero on 21/9/18.
//  Copyright © 2018 Marc Tamarit. All rights reserved.
//

import UIKit
import FoldingCell

struct Towns: Codable {
    let Brastlewark: [Gnome]
}

class ViewController: UIViewController {
    enum Const {
        static let closeCellHeight: CGFloat = 179
        static let openCellHeight: CGFloat = 400
    }
    
    let urlString = "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json"
    var keysSearch: [String] = [SearchKeys.kName, SearchKeys.kId, SearchKeys.kAge, SearchKeys.kWeight, SearchKeys.kHairColor, SearchKeys.kProfessions, SearchKeys.kFriends]
    var keyForSearch = SearchKeys.kName
    var gnomes = [Gnome]()
    var filteredGnomes = [Gnome]()
    var dataRetriever = DataRetriever()
    var filter = Filter()
    var cellHeights: [CGFloat] = Array(repeating: Const.closeCellHeight, count: 0)
    var professions = Professions()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchPickerView: UIPickerView!
    @IBOutlet weak var professionsPickerView: UIPickerView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
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
        
        //Set up professionsPickerView
        professionsPickerView.delegate = self
        professionsPickerView.dataSource = self

        //Fetch data if Internet is available
        if Reachability.isConnectedToNetwork(){
            dataRetriever.delegate = self
            dataRetriever.retriveDataFrom(urlString: urlString)
        }
        
        //Hide keyboard when scroll
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
    }
}

//MARK: - DataRetriever
extension ViewController: DataRetrieverDelegate{
    func dataRetrievedSuccess(gnomes:[Gnome]){
        DispatchQueue.main.async {
            //First time filtered and gnomes are the same
            self.gnomes = gnomes
            self.filteredGnomes = self.gnomes
            
            //fill array with gnomes for filter
            self.filter.gnomes = self.gnomes
            
            //Recalc height of cells
            self.cellHeights = Array(repeating: Const.closeCellHeight, count: self.filteredGnomes.count)
            
            //Get all professions and reload the component
            self.professions.fillKeysWith(gnomes: self.gnomes)
            self.professionsPickerView.reloadComponent(0)
            
            //Stop load indicator
            self.indicatorView.stopAnimating()
            
            //Reload the main tableView
            self.tableView.reloadData()

        }
    }
}

//MARK: - TableView
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGnomes.count
    }
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as GnomeFoldingTableViewCell = cell else {
            return
        }
        
        //Check if cell is expanded or collapsed
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        //Fill views
        let gnome = filteredGnomes[indexPath.row]
        cell.nameGnome = gnome.name
        cell.weight = gnome.weight
        cell.height = gnome.height
        cell.age = gnome.age
        cell.hairColor = gnome.hair_color
        cell.profileFGImgeView.loadImageWithUrl(gnome.thumbnail)             //Get image cached
        cell.profileContainerImageView.loadImageWithUrl(gnome.thumbnail)     //Get image cached
        cell.number = gnome.id
        cell.friends = gnome.friends
        cell.professions = gnome.professions
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingGnomeCell", for: indexPath) as! GnomeFoldingTableViewCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
        
        hideKeyboard()
    }
}

//MARK: - SearchBar
extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Get filtered gnomes with text typed
        filteredGnomes = filter.getBy(key: keyForSearch, searchText: searchText)
        
        if searchText.isEmpty{
            filteredGnomes = self.gnomes
        }
        
        //Recalc height of cells
        cellHeights = Array(repeating: Const.closeCellHeight, count: filteredGnomes.count)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        hideKeyboard()
    }
}

//MARK: - PickersView
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
        case searchPickerView:
            return 1
        case professionsPickerView:
            return 1
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case searchPickerView:
            return keysSearch.count
        case professionsPickerView:
            return professions.professionsKeys.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case searchPickerView:
            return keysSearch[row]
        case professionsPickerView:
            return professions.professionsKeys[row]
        default:
            return keysSearch[0]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        switch pickerView {
        case searchPickerView:
            keyForSearch = keysSearch[row]
            filteredGnomes = self.gnomes
            
            //Hide or show searchView and professionsPickerView
            handleSearchers()
            
            //Check if keyboard need Digital or Alphabet
            refreshKeyboard()
            
        case professionsPickerView:
            //Get filtered gnomes with key tapped
            filteredGnomes = filter.getBy(key: keyForSearch, searchText: professions.professionsKeys[row])
            
            //Recalc height of cells
            cellHeights = Array(repeating: Const.closeCellHeight, count: filteredGnomes.count)
        default:
            print("Unknow picker")
        }
        tableView.reloadData()
    }
    
    func handleSearchers(){
        if keyForSearch == SearchKeys.kProfessions{
            searchBar.isHidden = true
            professionsPickerView.isHidden = false
        }else{
            searchBar.isHidden = false
            professionsPickerView.isHidden = true
        }
    }
}

// MARK: - Keyboard
extension ViewController{
    func refreshKeyboard(){
        hideKeyboard()
        if keyForSearch != SearchKeys.kProfessions{
            self.searchBar.keyboardType =  (KeyboardHandler.requiresDecimal(key: keyForSearch)) ? UIKeyboardType.decimalPad : UIKeyboardType.alphabet
            searchBar.becomeFirstResponder()
        }
    }
    
    func showKeyboard(){
        searchBar.becomeFirstResponder()
    }
    
    func hideKeyboard(){
        searchBar.endEditing(true)
    }
}
