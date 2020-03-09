//
//  AcceuilView.swift
//  Projet AWI - Mobile
//
//  Created by user165586 on 01/03/2020.
//  Copyright © 2020 Remy McConnell. All rights reserved.
//

import SwiftUI

struct AcceuilView: View {
    @EnvironmentObject var appState : AppState
    var body: some View {
        VStack{
            if (self.appState.isConnected){
                Acceuil()
            }else{
                Acceuil()
            }
        }
    }
}

struct Acceuil: View {
    @EnvironmentObject var appState : AppState
    
    var mode : NavigationBarItem.TitleDisplayMode {
        get {
            if (self.appState.isConnected){
                return .automatic
            }else{
                return .inline
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            NavigationView{
                ListPostView(title: "Our App", rech: false, posts: [])
                    .navigationBarTitle("Our App", displayMode: mode)
                    .navigationBarItems(trailing:
                    VStack{
                    if (!self.appState.isConnected){
                        NavigationLink(destination: ConnexionView(), label: {
                            Image(systemName: "power").font(.system(size: 25)).foregroundColor(Color.blue)
                        })
                    }else{
                        Button(action: {
                            self.appState.isConnected.toggle()
                            self.appState.utilisateur = Utilisateur(token: "", data: Data(_id: "", pseudo: "", email: ""))
                            
                            // Ici on doit supprimer les infos du fichier JSON qu'on créera pour stockées les données de l'utilisateur
                        }) {
                            Image(systemName: "power").font(.system(size: 25)).foregroundColor(Color.red)
                        }
                    }
                })
            }
            if(self.appState.isConnected){
                BoutonEcrirePost().padding(20)
            }
        }
        
    }
}

struct BoutonEcrirePost : View {
    @State var details : Bool = false
    var body : some View {
        ZStack{
            if(!details){
                Circle()
                .foregroundColor(Color.white)
                .frame(width: 50, height: 50)
            }
            VStack{
                if(details){
                    OneButton(image: "plus.circle.fill", postBouton: false)
                    // OneButton(image: "plus.circle.fill", postBouton: false)
                }
                Button(action: {
                    withAnimation{
                        self.details.toggle()
                    }
                }, label: {
                    if(details){
                        Image(systemName: "plus.app").resizable()
                        .frame(width: 50, height: 50)
                    }else{
                        Image(systemName: "plus.circle.fill").resizable()
                        .frame(width: 50, height: 50)
                    }
                })
            }
            
        }
            
        
    }
}

struct OneButton : View {
    var image : String
    @State var postBouton : Bool
    
    var body : some View{
        ZStack{
        Circle()
            .foregroundColor(Color.white)
            .frame(width: 40, height: 40)
            
            Button(action: {
                self.postBouton = true
            }, label: {
                Image(systemName: image).resizable()
                    .frame(width: 40, height: 40)
            }).sheet(isPresented: self.$postBouton
                ,onDismiss: {
                    self.postBouton = false
                }, content: {
                    EcrirePostView(texte: "", postBouton: self.$postBouton)
                })
        }.transition(.move(edge: .trailing))
    }
}
/*
struct AcceuilView_Previews: PreviewProvider {
    static var previews: some View {
        AcceuilView()
    }
}
*/
