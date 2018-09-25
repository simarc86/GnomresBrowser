//
//  KeyboarHelper.swift
//  GnomesBrowser
//
//  Created by Marc Tamarit Romero on 24/9/18.
//  Copyright © 2018 Marc Tamarit. All rights reserved.
//

import Foundation


class KeyboardHandler {
    static func requiresDecimal(key: String) -> Bool{
        switch key {
        case "age":
            return true
        case "weight":
            return true
        case "height":
            return true
        default:
            return false
        }
    }
}
