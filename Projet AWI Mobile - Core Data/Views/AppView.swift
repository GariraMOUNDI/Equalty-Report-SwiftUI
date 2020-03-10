//
//  ContentView.swift
//  Projet AWI - Mobile
//
//  Created by Remy McConnell on 2/25/20.
//  Copyright © 2020 Remy McConnell. All rights reserved.
//

import SwiftUI


struct AppView: View {
    @EnvironmentObject var appState : AppState
    @Environment(\.managedObjectContext) var managedObjectContext
//    @FetchRequest(fetchRequest: Donnees.getDonnees()) var donnees : FetchedResults<Donnees>
//    
    init() {	
        self.inscrireUtilisateur()
        //let utilisateur = self.donnees[0]
        //self.appState.verifierInfo(pseudo: utilisateur.pseudo  , mdp: utilisateur.mdp)
//        ForEach(self.donnees){ d in
//            Text("\(d.pseudo)   \(d.mdp)")
//        }
    }
    var body: some View {
    
        HStack{
            if (self.appState.isConnected) {
               PagePrincipaleView()
            }else{
                AcceuilView()
            }
        }
    }
    
    func inscrireUtilisateur(){
        // J'inscris l'utilisateur dans la base de données et je le récupère pour ensuite l'enregistrer dans le Core Data
        
//        let utilisateur = Donnees(context: self.managedObjectContext)
//        utilisateur.pseudo = "admin"
//        utilisateur.mdp = "password"
//
//         do {
//            try self.managedObjectContext.save()
//         }catch{
//            print(error)
//        }
        
    }
}


