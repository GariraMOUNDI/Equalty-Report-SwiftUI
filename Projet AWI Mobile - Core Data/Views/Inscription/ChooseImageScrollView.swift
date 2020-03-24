//
//  ChooseImageScrollView.swift
//  Projet AWI Mobile - Core Data
//
//  Created by user165586 on 21/03/2020.
//  Copyright © 2020 moundi. All rights reserved.
//

import SwiftUI

struct ChooseImageScrollView: View {
    @EnvironmentObject var appState : AppState
    @Binding var imageChoisi : String
    @State var scroll : Bool = false
    
    var body: some View {
        VStack{
            Text("Choisissez une photo de profil : ").font(.system(size : 18))
            if(!scroll) {
                ZStack(alignment: .bottomTrailing){
                    Image(imageChoisi)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .cornerRadius(30)
                    .shadow(radius: 10)
                    ZStack{
                        Circle().frame(width: 30, height: 30).foregroundColor(Color.white).shadow(radius: 10)
                        Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color(red: 186/255, green: 85/255, blue: 211/255, opacity: 1))
                        .onTapGesture {
                            self.scroll.toggle()
                        }
                    }.offset(x: 8, y:8)
                }
            }else{
                ScrollView(.horizontal, showsIndicators: true){
                    HStack{
                        ForEach(self.appState.photos, id: \.self){ img in
                            Image(img)
                                .resizable()
                                .frame(width: 70, height: 70)
                                .cornerRadius(30)
                                .shadow(radius: 10)
                                .onTapGesture {
                                    self.imageChoisi = img
                                    self.scroll.toggle()
                                }
                        }
                    }
                }.frame(width: 230)
            }
        }
    }
}
