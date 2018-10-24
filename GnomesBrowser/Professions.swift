//
//  ProfessionsKeys.swift
//  GnomesBrowser
//
//  Created by Marc Tamarit Romero on 27/9/18.
//  Copyright © 2018 Marc Tamarit. All rights reserved.
//

import UIKit

class Professions: NSObject {
    var professionsKeys = [String]()
    
    //Fill with all different professions
    func fillKeysWith(gnomes: [Gnome]){
        for gnome in gnomes{
            for profession in gnome.professions{
                if !professionsKeys.contains(profession){
                    professionsKeys.append(profession)
                }
            }
        }
    }
}
