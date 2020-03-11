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
                ListPostView(rech: false, posts: [])
                    .navigationBarTitle("Equal Report", displayMode: mode)
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
                    OneButton(image: "pencil.circle.fill", postBouton: false)
                }
                Button(action: {
                    withAnimation{
                        self.details.toggle()
                    }
                }, label: {
                    if(details){
                        ZStack{
                            Circle()
                                .foregroundColor(Color.blue)
                            .frame(width: 50, height: 50)
                            Image(systemName: "minus.magnifyingglass").resizable()
                                .frame(width: 35, height: 35).foregroundColor(Color.white)
                        }
                    }else{
                        ZStack{
                            Circle()
                                .foregroundColor(Color.blue)
                            .frame(width: 50, height: 50)
                            Image(systemName: "plus.magnifyingglass").resizable()
                                .frame(width: 35, height: 35).foregroundColor(Color.white)
                        }
                    }
                })
            }
        }
    }
}

struct OneButton : View {
    var image : String
    @EnvironmentObject var appState : AppState
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
                    EcrirePostView(texte: "", postBouton: self.$postBouton).environmentObject(self.appState)
                })
        }.transition(.move(edge: .top))
    }
}
/*
struct AcceuilView_Previews: PreviewProvider {
    static var previews: some View {
        AcceuilView()
    }
}
*/
