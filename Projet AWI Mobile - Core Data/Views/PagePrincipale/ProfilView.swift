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
    @State var mdp : String = ""
    @State var cmdp : String = ""
    @State var alert : Bool = false
    @State var imageChoisi : String = ""
    
    var body: some View {
        NavigationView {
            ZStack{
                LogoView(width: 215, height: 150, bottom: 0, radius: 40).opacity(0.2)
                VStack {
                    Spacer()
                    if (!self.appState.modifierUtilisateur){
                        Image(self.appState.utilisateur.data.photo).resizable().frame(width: 100.0, height: 100.0).cornerRadius(20).shadow(color: Color(red: 93/255, green: 93/255, blue: 187/255), radius: 10, x: 0, y: 0)
                        HStack(spacing: 20.0){
                            VStack(alignment: .leading, spacing: 20.0){
                                Text("Pseudo : ")
                                    .font(.title)
                                    .fontWeight(.medium)
                                    .bold()
                                Text("E-mail : ")
                                    .font(.title)
                                    .fontWeight(.medium)
                                    .bold()
                            }
                            VStack(alignment: .leading, spacing: 20.0){
                                Text(self.appState.utilisateur.data.pseudo).font(.title).fontWeight(.regular)
                                Text(self.appState.utilisateur.data.email).font(.title).fontWeight(.regular)
                            }
                        }.padding(.vertical, 20.0)
                        
                        HStack(spacing: 20){
                            Button(action: {
                                self.alert.toggle()
                            }){ Text("Supprimer").foregroundColor(Color.white).frame(width: 100, height: 40.0).background(Color.red).cornerRadius(20).shadow(color: Color(red: 93/255, green: 93/255, blue: 187/255), radius: 10, x: 0, y: 0).shadow(radius: 10)
                            }
                            
                            Button(action: {
                                self.appState.modifierUtilisateur.toggle()
                            }){ Text("Modifier").foregroundColor(Color.white).frame(width: 100, height: 40.0).background(Color.green).cornerRadius(20).shadow(color: Color(red: 93/255, green: 93/255, blue: 187/255), radius: 10, x: 0, y: 0).shadow(radius: 10)
                            }
                        }
                    }else{
                        ChooseImageScrollView(imageChoisi: self.$imageChoisi)
                        ScrollView(.vertical){
                            ModifierView(email: self.appState.utilisateur.data.email, pseudo: self.appState.utilisateur.data.pseudo, mdp: "", amdp: "", cmdp: "",ancienUtilisateur: self.appState.utilisateur, imageChoisi: self.$imageChoisi)
                        }
                    }
                    Spacer().navigationBarTitle("Profil")
                }
            }
                }.tabItem{
                VStack{
                    Image(systemName: "person.crop.circle").font(.system(size: 25))
                }
            }.alert(isPresented: self.$alert, content: {
                Alert(title: Text("Suppression de compte"),
                      message: Text("Voulez-vous vriment supprimer ce compte ?\n Cet action est irréversible."),
                      primaryButton: .destructive(Text("Oui"), action: {
                            self.appState.requeteUtilisateur(type: .Supprimer)
                    }),
                      secondaryButton: .default(Text("Non"), action: {
                            self.alert.toggle()
                      }))
            })
    }
}
