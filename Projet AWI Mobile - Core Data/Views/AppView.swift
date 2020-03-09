//
//  ContentView.swift
//  Projet AWI - Mobile
//
//  Created by Remy McConnell on 2/25/20.
//  Copyright © 2020 Remy McConnell. All rights reserved.
//

import SwiftUI

struct AppView: View {
    @EnvironmentObject var appState : AppState
    var body: some View {
        HStack{
            if (self.appState.isConnected) {
               PagePrincipaleView()
            }else{
                AcceuilView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
