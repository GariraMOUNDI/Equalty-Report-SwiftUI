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
    
    @State var filtre : Bool = false
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
                            Image(systemName: "power").font(.system(size: 25)).foregroundColor(Color(red: 93/255, green: 93/255, blue: 187/255))
                            }
                        )
                    }else{
                        Button(action: {
                            self.appState.isConnected.toggle()
                            self.appState.utilisateur = Utilisateur(token: "", data: Data(_id: "", pseudo: "", email: ""))
                            self.appState.getPost()
                        }) {
                            Image(systemName: "power").font(.system(size: 25)).foregroundColor(Color.red)
                        }
                    }
                })
            }
            if(self.appState.isConnected){
                BoutonEcrirePost(filtre: self.$filtre).padding(20)
            }
            
            if(self.filtre){
                FiiltreView(filtre: self.$filtre)
            }
        }
    }
}

struct BoutonEcrirePost : View {
    @State var details : Bool = false
    @Binding var filtre : Bool
    
    var body : some View {
        ZStack{
            if(!details){
                Circle()
                .foregroundColor(Color(red: 93/255, green: 93/255, blue: 187/255))
                .frame(width: 50, height: 50)
            }
            VStack{
                if(details){
                    OneButton(image: "plus.circle.fill", filtre: self.$filtre, tag: 2)
                    
                    OneButton(image: "pencil.circle.fill", filtre: self.$filtre, tag: 1)
                }
                Button(action: {
                    withAnimation{
                        self.details.toggle()
                    }
                }, label: {
                    if(details){
                        ZStack{
                            Circle()
                                .foregroundColor(Color(red: 93/255, green: 93/255, blue: 187/255))
                            .frame(width: 50, height: 50)
                            Image(systemName: "minus.magnifyingglass").resizable()
                                .frame(width: 35, height: 35).foregroundColor(Color.white)
                        }
                    }else{
                        ZStack{
                            Circle()
                                .foregroundColor(Color(red: 93/255, green: 93/255, blue: 187/255))
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
    @State var postBouton : Bool = false
    @Binding var filtre : Bool
    var tag : Int
    
    var body : some View{
        ZStack{
        Circle()
            .foregroundColor(Color.white)
            .frame(width: 40, height: 40)
            Button(action: {
                switch self.tag {
                case 1 :
                    self.postBouton = true
                    break
                case 2 :
                    self.filtre = true
                    break
                default : return
                }
            }, label: {
                Image(systemName: image).resizable()
                    .frame(width: 40, height: 40).foregroundColor(Color(red: 93/255, green: 93/255, blue: 187/255))
            }).sheet(isPresented: self.$postBouton
                ,onDismiss: {
                    self.postBouton = false
                }, content: {
                    EcrirePostView(texte: "", postBouton: self.$postBouton).environmentObject(self.appState)
                })
            }.transition(.move(edge: .top))
    }
}

struct FiiltreView : View {
    @EnvironmentObject var appState : AppState
    @Binding var filtre : Bool
    var body : some View {
        VStack{
            HStack{
                Text("Filtres")
                    .fontWeight(.medium).bold().font(.largeTitle).padding(.top, 20)
                Spacer()
            }
            ForEach(self.appState.filterLabels, id: \.self) { label in
                Button(action: {
                    self.appState.filtrerPosts(filtre: label)
                    self.filtre.toggle()
                }, label: {
                    Text(label).font(.system(size: 20))
                    }).foregroundColor(Color.black).padding(7)
            }
        }.padding(.horizontal, 15)
            .padding(.bottom, 15)
            .background(Color.white).cornerRadius(20).opacity(0.9)
    }
}
