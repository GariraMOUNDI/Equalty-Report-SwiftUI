//
//  EcrirePostView.swift
//  Projet AWI - Mobile
//
//  Created by user165586 on 06/03/2020.
//  Copyright © 2020 Remy McConnell. All rights reserved.
//

import SwiftUI

struct EcrirePostView: View {
    @State var texte : String
    @Binding var postBouton : Bool
    @State var responder : Bool = false
    @EnvironmentObject var appState : AppState
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("Publier")
                    .fontWeight(.medium).bold().font(.largeTitle).padding(.top, 20)
                Spacer()
                Button(action: {
                    self.appState.creerCommentaireOuPost(createur: self.appState.utilisateur.id, parentId: "", texte: self.texte)
                    self.postBouton.toggle()
                }){
                    Image(systemName: "tray.and.arrow.up.fill")
                        .font(.system(size: 30)).foregroundColor(Color.blue)
                }.padding(.top, 10)
            }
            VStack(alignment: .center, spacing: 30){
                Text(" Qu'es ce qui vous viens à l'esprit ?\n Dites le nous.\n Partagez et voyez ce que les autres en pensent.")
                    .fontWeight(.medium).bold().font(.system(size: 15)).padding(.top, 20).multilineTextAlignment(.center)
                TextView(placeholderText: "Ecrivez un post ...", text: self.$texte).frame(numLines: 15).cornerRadius(15)
                Image("Flame").resizable()
                    .frame(width: 130, height: 130, alignment: .center).cornerRadius(40).opacity(0.5)
            }.padding(.top, 30)
            Spacer()
        }.padding(.horizontal, 15)
    }
}

//struct EcrirePostView_Previews: PreviewProvider {
//    static var previews: some View {
//        EcrirePostView()
//    }
//}
