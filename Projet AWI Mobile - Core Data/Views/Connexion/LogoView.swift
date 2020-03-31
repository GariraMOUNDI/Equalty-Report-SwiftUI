//
//  Logo.swift
//  Projet AWI - Mobile
//
//  Created by user165586 on 25/02/2020.
//  Copyright © 2020 Remy McConnell. All rights reserved.
//

import SwiftUI

struct LogoView: View {
    var width : CGFloat
    var height : CGFloat
    var bottom : CGFloat
    var radius : CGFloat
    var body: some View {
        VStack{
            HStack(spacing: 30.0){
                Image("Flame")
                    .resizable()
                    .frame(width: width, height: height).cornerRadius(radius).shadow(color: Color(red: 93/255, green: 93/255, blue: 187/255), radius: 10, x:0, y:0)
            }.padding(.bottom, bottom)
        }
    }
}
