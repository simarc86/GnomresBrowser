//
//  Filter.swift
//  GnomesBrowser
//
//  Created by Marc Tamarit Romero on 23/9/18.
//  Copyright © 2018 Marc Tamarit. All rights reserved.
//

import UIKit

class Filter: NSObject {
    var gnomes: [Gnome]!
    
    func getBy(key: String, searchText: String) -> [Gnome]{
        switch key {
        case SearchKeys.kName:
            let filtered = gnomes.filter{ $0.name.lowercased().contains(searchText.lowercased()) }
            return filtered
        case SearchKeys.kAge:
            return gnomes.filter{ $0.age == Int(searchText)}
        case SearchKeys.kHeight:
            return gnomes.filter{ Int($0.height) == Int(searchText)}
        case SearchKeys.kWeight:
            return gnomes.filter{ Int($0.weight) == Int(searchText)}
        case SearchKeys.kHairColor:
            return gnomes.filter{ $0.hair_color == searchText.lowercased()}
        default:
            return gnomes
        }
    }
}
