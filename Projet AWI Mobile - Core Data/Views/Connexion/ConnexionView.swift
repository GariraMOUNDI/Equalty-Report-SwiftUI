//
//  LoginView.swift
//  Projet AWI - Mobile
//
//  Created by user165586 on 28/02/2020.
//  Copyright © 2020 Remy McConnell. All rights reserved.
//

import SwiftUI

struct ConnexionView: View {
    var body: some View {
            VStack{
                LogoView(width: 250, height: 150, bottom: 10, radius: 40)
                    .padding(.top, 60.0)
                FormView(pseudo: "", mdp: "",topButton: 20)
            }
    }
}
/*
structConnexionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnexionView()
    }
}
 */
