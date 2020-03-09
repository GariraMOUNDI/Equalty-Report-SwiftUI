//
//  Utilisateur.swift
//  Projet AWI - Mobile
//
//  Created by user165586 on 01/03/2020.
//  Copyright © 2020 Remy McConnell. All rights reserved.
//

import SwiftUI

struct Utilisateur : Codable {
    var token : String
    var data : Data
//    var id : String{
//        get{
//            return data._id
//        }
//    }
}

struct Data : Codable {
    var _id : String
    var pseudo : String
    var email : String
}
