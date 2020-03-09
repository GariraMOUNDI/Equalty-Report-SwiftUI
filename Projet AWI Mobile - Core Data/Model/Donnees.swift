//
//  Donnees.swift
//  Projet AWI Mobile - Core Data
//
//  Created by user165586 on 08/03/2020.
//  Copyright © 2020 moundi. All rights reserved.
//

import Foundation
import CoreData

public class Donnees: NSManagedObject, Identifiable{
    
    @NSManaged public var pseudo : String
    @NSManaged public var mdp : String
    
}

extension Donnees {
    static func getDonnees() -> NSFetchRequest<Donnees> {
        let request : NSFetchRequest<Donnees> = Donnees.fetchRequest() as! NSFetchRequest<Donnees>
        
        let descriptor = NSSortDescriptor(key : "pseudo", ascending : true)
        
        request.sortDescriptors = [descriptor]
        
        return request
    }
}
