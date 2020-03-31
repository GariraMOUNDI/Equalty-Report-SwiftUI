//
//  RegisterView.swift
//  Projet AWI - Mobile
//
//  Created by user165586 on 25/02/2020.
//  Copyright © 2020 Remy McConnell. All rights reserved.
//

import SwiftUI

struct InscriptionView: View {
    @State var pseudo: String
    @State var mdp: String
    @State var email: String
    @State var cmdp: String
    var topButton: CGFloat
    @State var alert : String = ""
    @EnvironmentObject var appState : AppState
    @State var inscrire : Bool = false
    @State var imageChoisi : String = "Flame"
    
    var body: some View {
        VStack{
            LogoView(width: 150, height: 90, bottom: 15, radius: 25)
            ChooseImageScrollView(imageChoisi: self.$imageChoisi)
            ScrollView(.vertical){
                VStack{
                    VStack(alignment: .leading, spacing: 10.0){
                        Text("Pseudo")
                            .font(.title)
                            .fontWeight(.medium)
                        TextField("Entrer votre pseudo", text: $pseudo)
                            .padding(20)
                                .frame(height: 40.0)
                                .background(Color(red: 211/255, green: 211/255, blue: 211/255, opacity: 1))
                            .cornerRadius(10)
                        .shadow(color: Color(red: 93/255, green: 93/255, blue: 187/255), radius: 10, x: 0, y: 0)
                    }
                    VStack(alignment: .leading, spacing: 10){
                        Text("E-mail")
                        .font(.title)
                        .fontWeight(.medium)
                        TextField("Entrer votre e-mail", text: $email)
                            .padding(20)
                                .frame(height: 40.0)
                                .background(Color(red: 211/255, green: 211/255, blue: 211/255, opacity: 1))
                            .cornerRadius(10)
                        .shadow(color: Color(red: 93/255, green: 93/255, blue: 187/255), radius: 10, x: 0, y: 0)
                    }
                    VStack(alignment: .leading, spacing: 10){
                        Text("Mot de passe")
                        .font(.title)
                        .fontWeight(.medium)
                        SecureField("Entrer votre mot de passe", text: $mdp)
                            .padding(20)
                                .frame(height: 40.0)
                                .background(Color(red: 211/255, green: 211/255, blue: 211/255, opacity: 1))
                            .cornerRadius(10)
                        .shadow(color: Color(red: 93/255, green: 93/255, blue: 187/255), radius: 10, x: 0, y: 0)
                    }
                    VStack(alignment: .leading, spacing: 10){
                        Text("Retaper votre mot de passe")
                        .font(.title)
                        .fontWeight(.medium)
                        SecureField("Entrer votre mot de passe", text:$cmdp )
                            .padding(20)
                                .frame(height: 40.0)
                                .background(Color(red: 211/255, green: 211/255, blue: 211/255, opacity: 1))
                            .cornerRadius(10)
                        .shadow(color: Color(red: 93/255, green: 93/255, blue: 187/255), radius: 10, x: 0, y: 0)
                    }
                }.padding(.bottom, topButton).padding(.horizontal, 20)
                
                    Button(action: {
                        let pseudo = self.pseudo.trimmingCharacters(in: .whitespacesAndNewlines)
                        let email = self.email.trimmingCharacters(in: .whitespacesAndNewlines)
                        if( self.imageChoisi != "Flame"){
                            if(pseudo != "" && email != "" && self.mdp != "" && self.cmdp != ""){
                                if(self.mdp == self.cmdp){
                                    self.appState.requeteUtilisateur(pseudo: pseudo, mdp: self.mdp, email: email, photo: self.imageChoisi, type: .Creer)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                        if(self.appState.utilisateur.id != ""){
                                            self.appState.isConnected = true
                                        }else{
                                            self.alert = "Cet utilisateur existe déja."
                                            self.inscrire.toggle()
                                        }
                                    })
                                }else{
                                    self.alert = "Le mot de passe confirmé ne correspond pas. \n Veuillez resaisir votre mot de passe."
                                    self.inscrire.toggle()
                                }
                            }else{
                                self.alert = "Veuillez remplir tous les champs."
                                self.inscrire.toggle()
                            }
                        }else{
                            self.alert = "Veuillez choisir une photo de profil en cliquant sur le stylet de l'icone."
                            self.inscrire.toggle()
                        }
                    }) {
                        Text("S'incrire").foregroundColor(Color.white)
                    }.padding(40)
                    .frame(height: 50.0).background(Color.green).cornerRadius(20).shadow(color: Color(red: 93/255, green: 93/255, blue: 187/255), radius: 10, x: 0, y: 0)
                    .alert(isPresented: $inscrire, content: {
                            Alert(title: Text("Inscription"),
                                  message: Text(self.alert),
                                  dismissButton: .default(Text("Ok"), action: { self.inscrire.toggle() }))
                        })
                    .shadow(radius: 10)
            }
        }.padding(.top, 10)
    }
}

