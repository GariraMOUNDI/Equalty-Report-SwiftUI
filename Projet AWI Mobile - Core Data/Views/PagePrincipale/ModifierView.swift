//
//  ModifierView.swift
//  Projet AWI - Mobile
//
//  Created by user165586 on 01/03/2020.
//  Copyright © 2020 Remy McConnell. All rights reserved.
//

import SwiftUI

struct ModifierView: View {
    @EnvironmentObject var appState : AppState
    @State var email : String
    @State var pseudo : String
    @State var mdp : String
    @State var amdp : String
    @State var cmdp : String
    @State var value : CGFloat = 0
    @State var  ancienMdp :  Bool = false
    @State var  alert : String = ""
    @State var ancienUtilisateur : Utilisateur
    @Binding var imageChoisi : String
    
    var body: some View {
        VStack{
        VStack{
            VStack(alignment: .leading, spacing: 10.0){
                Text("Pseudo")
                    .font(.title)
                    .fontWeight(.medium)
                TextField("Entrer votre pseudo", text: self.$pseudo)
                    .padding(20)
                        .frame(height: 40.0)
                        .background(Color(red: 211/255, green: 211/255, blue: 211/255, opacity: 1))
                    .cornerRadius(10).shadow(color: Color(red: 93/255, green: 93/255, blue: 187/255), radius: 10, x: 0, y: 0)
            }
            VStack(alignment: .leading, spacing: 10){
                Text("E-mail")
                .font(.title)
                .fontWeight(.medium)
                TextField("Entrer votre e-mail", text: self.$email)
                    .padding(20)
                        .frame(height: 40.0)
                        .background(Color(red: 211/255, green: 211/255, blue: 211/255, opacity: 1))
                    .cornerRadius(10).shadow(color: Color(red: 93/255, green: 93/255, blue: 187/255), radius: 10, x: 0, y: 0)
            }
            VStack(alignment: .leading, spacing: 10){
                Text("Ancien mot de passe")
                .font(.title)
                .fontWeight(.medium)
                SecureField("Entrer votre mot de passe", text: self.$amdp)
                    .padding(20)
                        .frame(height: 40.0)
                        .background(Color(red: 211/255, green: 211/255, blue: 211/255, opacity: 1))
                    .cornerRadius(10).shadow(color: Color(red: 93/255, green: 93/255, blue: 187/255), radius: 10, x: 0, y: 0)
            }
            VStack(alignment: .leading, spacing: 10){
                Text("Nouveau mot de passe")
                .font(.title)
                .fontWeight(.medium)
                SecureField("Entrer votre mot de passe", text: self.$mdp)
                    .padding(20)
                        .frame(height: 40.0)
                        .background(Color(red: 211/255, green: 211/255, blue: 211/255, opacity: 1))
                    .cornerRadius(10).shadow(color: Color(red: 93/255, green: 93/255, blue: 187/255), radius: 10, x: 0, y: 0)
            }
            VStack(alignment: .leading, spacing: 10){
                Text("Confirmer votre mot de passe")
                .font(.title)
                .fontWeight(.medium)
                SecureField("Entrer votre mot de passe", text: self.$cmdp )
                    .padding(20)
                        .frame(height: 40.0)
                        .background(Color(red: 211/255, green: 211/255, blue: 211/255, opacity: 1))
                    .cornerRadius(10).shadow(color: Color(red: 93/255, green: 93/255, blue: 187/255), radius: 10, x: 0, y: 0)
            }
        }.padding(.bottom, 10)
            
            HStack(spacing: 20){
                
                Button(action: {
                    self.appState.utilisateur = self.ancienUtilisateur
                    self.appState.modifierUtilisateur.toggle()
                }){
                    Text("Annuler").foregroundColor(Color.white).frame(width: 120.0, height: 40.0).background(Color.blue).cornerRadius(20)
                        .shadow(color: Color(red: 93/255, green: 93/255, blue: 187/255), radius: 10, x: 0, y: 0).shadow(radius: 10)
                }.shadow(radius: 10)
                
                Button(action: {
                    let pseudo = self.pseudo.trimmingCharacters(in: .whitespacesAndNewlines)
                    let email = self.email.trimmingCharacters(in: .whitespacesAndNewlines)
                    let ancienPseudo = self.ancienUtilisateur.data.pseudo
                    
                    if (pseudo != "" && email != "" && self.amdp != "" && self.mdp != "" && self.cmdp != ""){
                        self.appState.requeteUtilisateur(pseudo: ancienPseudo, mdp : self.amdp, type: .Lire)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                if( self.appState.utilisateur.token == ""){
                                    self.alert = "L'ancien mot de passe ne correspond pas.\n Veuillez vérifier qu'il a été bien saisi"
                                    self.ancienMdp.toggle()
                                }else{
                                    var executer = true
                                    if(pseudo != ancienPseudo){
                                        self.appState.checkExistance(pseudo: pseudo)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                                            if(!self.appState.check.success){
                                                executer = false
                                            }
                                        })
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute:  {
                                        if(executer){
                                            if(self.mdp != self.cmdp){
                                                self.alert = "Le mot de passe confirmer ne correspond pas. \n Veuillez saisir exactement votre nouveau mot de passe pour le confirmer"
                                                self.ancienMdp.toggle()
                                            }else{
                                                self.appState.requeteUtilisateur(pseudo: pseudo, mdp: self.mdp, email: email, photo: self.imageChoisi, type: .Modifier)
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {                                   self.appState.modifierUtilisateur.toggle()
                                                    self.appState.getPost()
                                                })
                                                print("c'est bon !!")
                                            }
                                        }else{
                                            self.alert = "Ce Pseudo existe déjà.\n Veuillez choisir un Pseudo différent de celui ci."
                                            self.ancienMdp.toggle()
                                        }
                                    })
                                }
                        })
                    }else{
                        self.alert = "Veuillez remplir tous les champs."
                        self.ancienMdp.toggle()
                    }
                }){
                    Text("Confirmer").foregroundColor(Color.white).frame(width: 120.0, height: 40.0).background(Color.red).cornerRadius(20)
                    .shadow(color: Color(red: 93/255, green: 93/255, blue: 187/255), radius: 10, x: 0, y: 0).shadow(radius: 10)
                }.alert(isPresented: self.$ancienMdp, content: {
                  Alert(title: Text("Modification"),
                        message: Text(self.alert),
                        dismissButton: .default(Text("Ok"), action: { self.ancienMdp.toggle() }))
                    }).shadow(radius: 10)
            }
        }.padding(.horizontal, 20)
        
}
}

