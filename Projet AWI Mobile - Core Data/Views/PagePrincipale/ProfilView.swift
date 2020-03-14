//
//  ProfileView.swift
//  Projet AWI - Mobile
//
//  Created by user165586 on 27/02/2020.
//  Copyright © 2020 Remy McConnell. All rights reserved.
//

import SwiftUI

struct ProfilView: View {
    @EnvironmentObject var appState : AppState
    @State var edit : Bool = false
    @State var mdp : String
    @State var cmdp : String
    
    var body: some View {
        NavigationView {
        VStack {
            Spacer()
            Image("Flame").resizable().frame(width: 100.0, height: 100.0).cornerRadius(20)
            
            if (!self.appState.modifierUtilisateur){
                HStack(spacing: 20.0){
                    VStack(alignment: .leading, spacing: 20.0){
                        Text("Pseudo : ")
                            .font(.title)
                            .fontWeight(.medium)
                        Text("E-mail : ")
                            .font(.title)
                            .fontWeight(.medium)
                    }
                    VStack(alignment: .leading, spacing: 20.0){
                        Text(self.appState.utilisateur.data.pseudo).font(.title).fontWeight(.regular)
                        Text(self.appState.utilisateur.data.email).font(.title).fontWeight(.regular)
                    }
                }.padding(.vertical, 20.0)
                HStack(spacing: 20){
                    Button(action: {
                        // Il faut supprimer l'élément de la base de données
                        //self.appState.modifierUtilisateur.toggle()
                    }){ Text("Supprimer").foregroundColor(Color.white).frame(width: 100, height: 40.0).background(Color.red).cornerRadius(20).shadow(radius: 10)
                    }
                    Button(action: {
                        self.appState.modifierUtilisateur.toggle()
                    }){ Text("Modifier").foregroundColor(Color.white).frame(width: 100, height: 40.0).background(Color.green).cornerRadius(20).shadow(radius: 10)
                    }
                }
                
            }else{
                ScrollView(.vertical){
                    ModifierView(email: self.appState.utilisateur.data.email, pseudo: self.appState.utilisateur.data.pseudo, mdp: "", amdp: "", cmdp: "",ancienUtilisateur: self.appState.utilisateur)
                }
            }
            Spacer().navigationBarTitle("Profil")
        }.padding(.horizontal, 20)
            }.tabItem{
            VStack{
                Image(systemName: "person.crop.circle").font(.system(size: 25))
            }
        }
    }
}
/*
struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView()
    }
}
*/
