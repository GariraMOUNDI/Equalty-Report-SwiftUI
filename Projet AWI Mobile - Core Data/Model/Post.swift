//
//  File.swift
//  Projet AWI - Mobile
//
//  Created by user165586 on 26/02/2020.
//  Copyright © 2020 Remy McConnell. All rights reserved.
//

import Foundation

struct Post : Identifiable, Codable {
    
    var id : String {   // Pour Identifiable
        get {
            return _id 
        }
    }
    var reactions : [String] = []
    var _id: String = ""
    var texte : String = ""
    var createur : Createur
    
}

struct Createur : Codable {
    var _id : String = ""
    var pseudo : String = ""
}
