//
//  AcceuilView.swift
//  Projet AWI - Mobile
//
//  Created by user165586 on 26/02/2020.
//  Copyright © 2020 Remy McConnell. All rights reserved.
//

import SwiftUI

struct PagePrincipaleView: View {
    @EnvironmentObject var appState : AppState
    
    var body: some View {
        TabView {
            AcceuilView().tabItem{
                    VStack{
                        Image(systemName: "house").font(.system(size: 25))
                    }
            }.tag(1)
            
            RechercherView(posts: self.appState.posts).tag(2)
            
            ProfilView(imageChoisi: self.appState.utilisateur.data.photo).tag(3)
        }.accentColor(Color(red: 93/255, green: 93/255, blue: 187/255))
    }
}

struct PagePrincipaleView_Previews: PreviewProvider {
    static var previews: some View {
        PagePrincipaleView()
    }
}
