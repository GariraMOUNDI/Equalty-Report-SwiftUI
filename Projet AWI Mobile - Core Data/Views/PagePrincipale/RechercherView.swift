//
//  RechercherView.swift
//  Projet AWI - Mobile
//
//  Created by user165586 on 27/02/2020.
//  Copyright © 2020 Remy McConnell. All rights reserved.
//

import SwiftUI

struct RechercherView: View {
    
    var posts : [Post]
    @State var rechercher :  String
    @State var value : CGFloat = 0
    var postToPrint : [Post]{
        get{
            return posts.filter({
                return $0.texte.lowercased().contains(self.rechercher.lowercased()) || $0.createur.pseudo.lowercased().contains(self.rechercher.lowercased())
            })
        }
    }
    
    var body: some View {
        VStack {
            NavigationView {
                if (postToPrint.count == 0 ) {
                    VStack{
                        Spacer()
                        Text("Veuillez saisir un mot ou une expression que vous avez lu.")
                            .multilineTextAlignment(.center)
                            .frame(width: 200.0).foregroundColor(Color.gray)
                        Spacer()
                    }.navigationBarTitle("Recherche")
                }else{
                    ListPostView(title: "Recherche", rech: true, posts: postToPrint)
                }
            }
            TextField("Rechercher", text: $rechercher)
                .padding(.horizontal, 20.0)
                .frame(height: 40)
                .background(Color(red: 211/255, green: 211/255, blue: 211/255, opacity: 1))
                .cornerRadius(10)
                .offset(y: -self.value)
                .onAppear{
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main){ noti in
                        let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                        let height = value.height
                        self.value = height
                    }
                    
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main){ noti in
                        self.value = 0
                    }
            }
            
        }.tabItem{
                VStack{
                    Image(systemName: "magnifyingglass").font(.system(size: 25))
                }
        }
    }
}
/*
struct RechercherView_Previews: PreviewProvider {
    static var previews: some View {
        RechercherView(posts: [], rechercher: "")
    }
}
*/
