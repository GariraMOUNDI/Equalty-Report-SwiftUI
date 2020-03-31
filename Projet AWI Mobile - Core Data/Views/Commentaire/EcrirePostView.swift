//
//  EcrirePostView.swift
//  Projet AWI - Mobile
//
//  Created by user165586 on 06/03/2020.
//  Copyright © 2020 Remy McConnell. All rights reserved.
//

import SwiftUI

struct EcrirePostView: View {
    @EnvironmentObject var appState : AppState
    @Binding var texte : String
    @Binding var postBouton : Bool
    @Binding var changerCouleur : Bool
    var signaler : Bool = false
    var title : String {
        get{
            if (!signaler) {
                return "Publier"
            }else{
                return "Signaler"
            }
        }
    }
    var descriptif : String {
        get {
            if(!signaler){
                return "Qu'es ce qui vous viens à l'esprit ?\n Dites le nous.\nPartagez et voyez ce que les autres en pensent."
            }else{
                return "On vous écoute. \nAvez-vous été victime de ce propos ? ou autre ? \nDites-nous ce qui s'est réellement passé."
            }
        }
    }
    var placeholder : String {
        get {
            if(!signaler){
                return "Ecrivez un post ..."
            }else{
                return "Signaler ce post/commentaire ..."
            }
        }
    }
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(self.title)
                    .fontWeight(.medium).bold().font(.largeTitle).padding(.top, 20)
                Spacer()
                Button(action: {
                    if (!self.signaler){
                        self.appState.creerCommentaireOuPost(createur: self.appState.utilisateur.id, parentId: "", texte: self.texte)
                        self.postBouton.toggle()
                    }else{
                        self.postBouton.toggle()
                        if(self.texte.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
                            self.changerCouleur.toggle()
                        }
                    }
                }){
                    Image(systemName: "tray.and.arrow.up.fill")
                        .font(.system(size: 30)).foregroundColor(Color(red: 93/255, green: 93/255, blue: 187/255))
                }.padding(.top, 10)
            }
            VStack(alignment: .center, spacing: 30){
                Text(self.descriptif)
                    .fontWeight(.medium).bold().font(.system(size: 15)).padding(.top, 20).multilineTextAlignment(.center)
                TextView(placeholderText: self.placeholder, text: self.$texte).frame(numLines: 15).cornerRadius(15).shadow(color: Color(red: 93/255, green: 93/255, blue: 187/255), radius: 10, x: 0, y: 0)
                LogoView(width: 215, height: 130, bottom: 0, radius: 40).opacity(0.5)
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
