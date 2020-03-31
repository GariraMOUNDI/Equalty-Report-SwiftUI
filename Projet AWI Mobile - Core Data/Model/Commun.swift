//
//  Commun.swift
//  Projet AWI Mobile - Core Data
//
//  Created by user165586 on 30/03/2020.
//  Copyright © 2020 moundi. All rights reserved.
//

import Foundation

// Pour l'utilisateur
struct Data : Codable {
    var _id : String = ""
    var pseudo : String = ""
    var email : String = ""
    var isAdmin : Bool!
    var photo : String = ""
}

// Pour les posts et les commentaires
struct Createur : Codable {
    var _id : String = ""
    var pseudo : String = ""
    var photo : String = ""
}

struct Signaler : Codable {
    var _id : String = ""
    var texte : String = ""
    
    func asDictionnary() -> [String : String] {
        return  ["_id" : _id, "texte" : texte]
    }
}

func serialisable(signaler: [Signaler]) -> [[String : String]] {
    var serializable : [[String : String]] = []
    for signal in signaler {
        serializable.append(signal.asDictionnary())
    }
    return serializable
}
