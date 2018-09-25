//
//  URLSession.swift
//  GnomesBrowser
//
//  Created by Marc Tamarit Romero on 21/9/18.
//  Copyright © 2018 Marc Tamarit. All rights reserved.
//

import Foundation

protocol DataRetrieverDelegate: class {
    func dataRetrievedSuccess(gnomes:[Gnome])
}

class DataRetriever: NSObject {
    weak var delegate: DataRetrieverDelegate?

    func retriveDataFrom(urlString:String){
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with:url, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            do {
                let brastlewark = try JSONDecoder().decode(Towns.self, from: data)
                self.delegate?.dataRetrievedSuccess(gnomes:brastlewark.Brastlewark)
            } catch let error as NSError {
                print(error)
            }
        }).resume()
    }
}

