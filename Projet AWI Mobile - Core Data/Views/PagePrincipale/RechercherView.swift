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
    @State var rechercher : String = ""
    @State var value : CGFloat = 0
    var postToPrint : [Post]{
        get{
            if(posts.count != 0){
                return posts.filter({
                    return $0.texte.lowercased().contains(self.rechercher.lowercased()) || $0.createur.pseudo.lowercased().contains(self.rechercher.lowercased())
                })
            }else{
                return []
            }
            
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
                            LogoView(width: 246, height: 130, bottom: 0, radius: 40).opacity(0.5)
                            Spacer()
                        }.navigationBarTitle("Recherche")
                    }else{
                        ListPostView(rech: true, posts: postToPrint).navigationBarTitle("Recherche")
                    }
                
            }
            TextField("Rechercher", text: $rechercher)
                .padding(.horizontal, 20.0)
                .frame(height: 40)
                .background(Color(red: 211/255, green: 211/255, blue: 211/255, opacity: 1))
                .cornerRadius(15)
                .offset(y: -self.value)
                .padding(.horizontal, 5).padding(.bottom, 5).shadow(color: Color(red: 93/255, green: 93/255, blue: 187/255), radius: 10, x: 0, y: 0)
        }.tabItem{
            Image(systemName: "magnifyingglass").font(.system(size: 25))
        }.onAppear{
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main){ noti in
                    let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    self.value = value.size.height                    }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main){ noti in
                    self.value = 0
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

