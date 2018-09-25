//
//  Gnome.swift
//  GnomesBrowser
//
//  Created by Marc Tamarit Romero on 21/9/18.
//  Copyright © 2018 Marc Tamarit. All rights reserved.
//

import Foundation

struct Gnome: Codable {
    let id: Int
    let name: String
    let thumbnail: URL
    let age: Int
    let weight: Double
    let height: Double
    let hair_color: String
    let professions: [String]
    let friends: [String]
}
