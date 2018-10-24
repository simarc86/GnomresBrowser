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

    //Return gnomes filtered by key
    func getBy(key: String, searchText: String) -> [Gnome]{
        switch key {
        case SearchKeys.kId:
            return gnomes.filter{ Int($0.id) == Int(searchText)}
        case SearchKeys.kName:
            return gnomes.filter{ $0.name.lowercased().contains(searchText.lowercased()) }
        case SearchKeys.kAge:
            return gnomes.filter{ $0.age == Int(searchText)}
        case SearchKeys.kHeight:
            return gnomes.filter{ Int($0.height) == Int(searchText)}
        case SearchKeys.kWeight:
            return gnomes.filter{ Int($0.weight) == Int(searchText)}
        case SearchKeys.kHairColor:
            return gnomes.filter{$0.hair_color.lowercased().contains(searchText.lowercased())}
        case SearchKeys.kFriends:
            return getFriendsWith(nameOfFriend: searchText)
        case SearchKeys.kProfessions:
            return gnomes.filter { $0.professions.contains(searchText) }
        default:
            return gnomes
        }
    }
    
    //Return gnome's friends who contains search typed
    func getFriendsWith(nameOfFriend: String) -> [Gnome]{
        var gnomesWithFriend = [Gnome]()
        for gnome in gnomes{
            for friend in gnome.friends{
                if friend.contains(nameOfFriend){
                    gnomesWithFriend.append(gnome)
                }
            }
        }
        return gnomesWithFriend
    }
}
