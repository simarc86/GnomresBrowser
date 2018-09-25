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
    let urlString = "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json"
    var keysSearch: [String] = [SearchKeys.kName, SearchKeys.kAge, SearchKeys.kWeight, SearchKeys.kHairColor, SearchKeys.kProfessions, SearchKeys.kFriends]
    var keyForSearch = SearchKeys.kName
    var gnomes = [Gnome]()
    var filteredGnomes = [Gnome]()
    var dataRetriever = DataRetriever()
    var filter = Filter()

    enum Const {
        static let closeCellHeight: CGFloat = 179
        static let openCellHeight: CGFloat = 488
    }
    
    var cellHeights: [CGFloat] = []

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Gnomes"
        
//        cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
        
        cellHeights = Array(repeating: Const.closeCellHeight, count: filteredGnomes.count)



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
            self.cellHeights = Array(repeating: Const.closeCellHeight, count: self.filteredGnomes.count)

            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGnomes.count
    }
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as GnomeFoldingTableViewCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
                
        let gnome = filteredGnomes[indexPath.row]
        cell.nameGnome = gnome.name
        cell.profileImageView.loadImageWithUrl(gnome.thumbnail)
        cell.number = gnome.id
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
    }
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let gnomes = filteredGnomes else {
//            return 0
//        }
//        return gnomes.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingGnomeCell", for: indexPath) as! GnomeFoldingTableViewCell
//
////        if let gnomes = filteredGnomes {
////            let gnome = gnomes[indexPath.row]
////            cell.nameLbl.text = gnome.name
////            cell.ageLbl.text = "\(gnome.age) years"
////            cell.imageGnome.loadImageWithUrl(gnome.thumbnail)
////        }
//        return cell
//    }
//
//
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//
//        //        if case let cell as FoldingCell = cell {
//        //            if cellHeights![indexPath.row] == C.CellHeight.close {
//        //                cell.selectedAnimation(false, animated: false, completion:nil)
//        //            } else {
//        //                cell.selectedAnimation(true, animated: false, completion: nil)
//        //            }
//        //        }
//
//
//
//        guard case let cell as GnomeFoldingTableViewCell = cell else {
//            return
//        }
//
//        cell.backgroundColor = .clear
//
//        if cellHeights[indexPath.row] == Const.closeCellHeight {
//            cell.unfold(false, animated: false, completion: nil)
//        } else {
//            cell.unfold(true, animated: false, completion: nil)
//        }
//
//        cell.number.text = String(indexPath.row)
//
//    }
//
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        guard case let cell as FoldingCell = tableView.cellForRow(at: indexPath as IndexPath) else {
//            return
//        }
//
//        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
//
//        var duration = 0.0
//        if cellIsCollapsed {
//            cellHeights[indexPath.row] = Const.openCellHeight
//            cell.unfold(true, animated: true, completion: nil)
//            duration = 0.5
//        } else {
//            cellHeights[indexPath.row] = Const.closeCellHeight
//            cell.unfold(false, animated: true, completion: nil)
//            duration = 0.8
//        }
//
//        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
//            tableView.beginUpdates()
//            tableView.endUpdates()
//        }, completion: nil)
//    }
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredGnomes = filter.getBy(key: keyForSearch, searchText: searchText)

        if searchText.isEmpty{
            filteredGnomes = self.gnomes
        }
        
        cellHeights = Array(repeating: Const.closeCellHeight, count: filteredGnomes.count)
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        keyForSearch = keysSearch[row]
        filteredGnomes = self.gnomes
        refreshKeyboard()
//        cellHeights = (0..<(filteredGnomes.count)).map { _ in C.CellHeight.close }

        tableView.reloadData()
    }
    
    func refreshKeyboard(){
        searchBar.endEditing(true)
        self.searchBar.keyboardType =  (KeyboardHandler.requiresDecimal(key: keyForSearch)) ? UIKeyboardType.decimalPad : UIKeyboardType.alphabet
        searchBar.becomeFirstResponder()
    }
}
