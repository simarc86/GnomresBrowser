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
        case SearchKeys.kId:
            return true
        case SearchKeys.kAge:
            return true
        case SearchKeys.kWeight:
            return true
        case SearchKeys.kHeight:
            return true
        default:
            return false
        }
    }
}
