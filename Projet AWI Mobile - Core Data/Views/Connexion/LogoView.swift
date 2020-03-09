//
//  Logo.swift
//  Projet AWI - Mobile
//
//  Created by user165586 on 25/02/2020.
//  Copyright © 2020 Remy McConnell. All rights reserved.
//

import SwiftUI

struct LogoView: View {
    var bottom : CGFloat
    var body: some View {
        VStack{
            HStack(spacing: 30.0){
                Image("Flame")
                    .resizable()
                    .frame(width: 90, height: 90)
                    .cornerRadius(30)
                
                    Text("Our Application")
                
            }.padding(.bottom, bottom)
        }
    }
}
/*
struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView(bottom: 30)
    }
}
*/
