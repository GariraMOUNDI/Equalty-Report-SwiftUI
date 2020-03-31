//
//  Commentaire.swift
//  Projet AWI Mobile - Core Data
//
//  Created by user165586 on 07/03/2020.
//  Copyright © 2020 moundi. All rights reserved.
//

import Foundation

struct Commentaire : Identifiable, Codable {
    var reactions : [String] = []
    var _id: String = ""
    var texte : String = ""
    var createur : Createur!
    var parentId : String = ""
    var dateCreation : String = ""
    var signaler : [Signaler] = []
    var id : String {   // Pour Identifiable
        get {
            return _id
        }
    }
    
    var date : String {
        let splitted1 = dateCreation.split(separator: "T")
        let spliteed2 = splitted1[1].split(separator: ".")
        let newDate = "\(splitted1[0]) \(spliteed2[0])"
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = formatter.date(from: newDate) {
            let interval = NSInteger(Date().timeIntervalSince(date))
            let seconds = interval % 60
            let minutes = (interval / 60) % 60
            let hours = (interval / 3600)
            if(minutes == 0){
                return "Il y a \(seconds)sec"
            }else{
                if(hours == 0){
                    return "Il y a \(minutes)min\(seconds)sec"
                }else{
                    if(hours < 24){
                        return "Il y a \(hours)h\(minutes)min\(seconds)sec"
                    }else{
                        formatter.dateFormat = "d MMM"
                        return "le " + formatter.string(from: date)
                    }
                }
            }
           
        } else {
           return dateCreation
        }
    }
    
}
