//
//  Commentaire.swift
//  Projet AWI Mobile - Core Data
//
//  Created by user165586 on 07/03/2020.
//  Copyright © 2020 moundi. All rights reserved.
//

import Foundation

class Commentaire : Identifiable, Codable {
    
    var id : String {   // Pour Identifiable
        get {
            return _id
        }
    }
    var reactions : [String] = []
    var _id: String = ""
    var texte : String = ""
    var createur : Createur!
    var parentId : String = ""
    var dateCreation : String = ""
    
}
