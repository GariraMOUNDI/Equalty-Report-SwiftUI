//
//  File.swift
//  Projet AWI - Mobile
//
//  Created by user165586 on 26/02/2020.
//  Copyright © 2020 Remy McConnell. All rights reserved.
//

import Foundation

class Post : Identifiable, Codable{
    var reactions : [String] = []
    var _id: String = ""
    var texte : String = ""
    var createur : Createur!
    var numCommentaires : Int = 0
    var dateCreation : String = ""
    var signaler : [Signaler] = []
    
    var id : String {   // Pour Identifiable
        get {
            return _id
        }
    }
    
    var interval : (Int, Date) {
        get{
            let splitted1 = dateCreation.split(separator: "T")
            let spliteed2 = splitted1[1].split(separator: ".")
            let newDate = "\(splitted1[0]) \(spliteed2[0])"
            
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = formatter.date(from: newDate) {
                return (NSInteger(Date().timeIntervalSince(date)), date)
            }else{
                return (-1, Date())
            }
        }
    }
    
    var date : String {
        get{
            let seconds = interval.0 % 60
            let minutes = (interval.0 / 60) % 60
            let hours = (interval.0 / 3600)
            
                if(minutes == 0){
                    return "Il y a \(seconds)sec"
                }else{
                    if(hours == 0){
                        return "Il y a \(minutes)min\(seconds)sec"
                    }else{
                        if(hours < 24){
                            return "Il y a \(hours)h\(minutes)min\(seconds)sec"
                        }else{
                             let formatter = DateFormatter()
                            formatter.dateFormat = "d MMM"
                            return "le " + formatter.string(from: interval.1)
                        }
                    }
                }
        }
    }
}

