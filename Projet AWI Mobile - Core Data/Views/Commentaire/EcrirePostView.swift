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
    @EnvironmentObject var appState : AppState
    var body: some View {
        VStack(alignment: .leading){
            Text("Publier")
                .fontWeight(.medium).bold().font(.largeTitle).padding(.top, 20)
            Spacer()
            Text(texte).multilineTextAlignment(.center)
            Spacer()
            HStack{
                TextField("Ecrire un post", text: self.$texte)
                    .padding(20)
                        .frame(height: 40.0)
                        .background(Color(red: 211/255, green: 211/255, blue: 211/255, opacity: 1))
                    .cornerRadius(10)
                Button(action: {
                    // On envoi une requete à la base de données pour obtenier l'id et ensuite on modifie la vue
                    self.postBouton.toggle()
                }){
                    Image(systemName: "tray.and.arrow.up.fill")
                        .font(.system(size: 25)).foregroundColor(Color.blue)
                }
            }
        }.padding(.horizontal, 15)
    }
}

//struct EcrirePostView_Previews: PreviewProvider {
//    static var previews: some View {
//        EcrirePostView()
//    }
//}
