//
//  Form.swift
//  Projet AWI - Mobile
//
//  Created by user165586 on 25/02/2020.
//  Copyright © 2020 Remy McConnell. All rights reserved.
//

import SwiftUI

struct FormView: View {
    @State var pseudo: String
    @State var mdp: String
    @EnvironmentObject var appState : AppState
    @State var connect : Bool = false
    var topButton : CGFloat
    
    var body: some View {
        VStack{
            VStack{
                VStack(alignment: .leading, spacing: 10.0){
                    Text("Pseudo")
                        .font(.title)
                        .fontWeight(.medium)
                    TextField("Entrer votre pseudo", text: $pseudo)
                    .padding(20)
                        .frame(height: 40.0)
                        .background(Color(red: 211/255, green: 211/255, blue: 211/255, opacity: 1))
                        .cornerRadius(10).shadow(color: Color(red: 93/255, green: 93/255, blue: 187/255), radius: 10, x: 0, y: 0)
                }.padding(.bottom)
                
                VStack(alignment: .leading, spacing: 10){
                    Text("Mot de passe")
                    .font(.title)
                    .fontWeight(.medium)
                    SecureField("Entrer votre mot de passe", text: $mdp)
                        .padding(20)
                        .frame(height: 40.0)
                        .background(Color(red: 211/255, green: 211/255, blue: 211/255, opacity: 1))
                    .cornerRadius(10).shadow(color: Color(red: 93/255, green: 93/255, blue: 187/255), radius: 10, x: 0, y: 0)
                }
            }.padding(.bottom, topButton)
            
                Button(action: {
                    self.appState.requeteUtilisateur(pseudo: self.pseudo.trimmingCharacters(in: .whitespacesAndNewlines), mdp: self.mdp, email: "", type: .Lire)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        if (self.appState.utilisateur.token != ""){
                            self.appState.getPost()
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                                self.appState.isConnected = true
                            })
                        }else{
                            self.connect.toggle()
                        }
                    })
                }){
                    Text("Se connecter").foregroundColor(Color.white).padding(30.0)
                    .frame(height: 50.0).background(Color.green).cornerRadius(20).shadow(color: Color(red: 93/255, green: 93/255, blue: 187/255), radius: 10, x: 0, y: 0)
            }.alert(isPresented: $connect, content: {
                Alert(title: Text("Connexion"), message: Text("Pseudo ou Mot de passe incorrect"), dismissButton: .default(Text("Ok"), action: {
                    self.connect.toggle()
                }))
                    }).shadow(radius: 10)
            
            NavigationLink(destination: InscriptionView(pseudo: "", mdp: "", email: "", cmdp: "",topButton: 15)){
                Text("Pas de compte ? Inscrivez-vous").foregroundColor(Color(red: 93/255, green: 93/255, blue: 187/255))
            }.padding(.top, 10)
            Spacer()
            
        }.padding(.horizontal, 20.0)
        
    }
}



struct Form_Previews: PreviewProvider {
    static var previews: some View {
        FormView(pseudo: "", mdp: "", topButton: 0)
    }
}
