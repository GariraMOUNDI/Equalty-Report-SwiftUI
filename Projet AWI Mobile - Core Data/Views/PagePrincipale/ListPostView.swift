//
//  ListPostView.swift
//  Projet AWI - Mobile
//
//  Created by user165586 on 27/02/2020.
//  Copyright © 2020 Remy McConnell. All rights reserved.
//

import SwiftUI

struct ListPostView: View {
    @EnvironmentObject var appState : AppState
    var postsToPrint : [Post] {
        get {
            if (rech) {
                return self.posts
            }else{
                return self.appState.posts
            }
        }
    }
    var rech : Bool
    var posts : [Post]
    var fram : CGRect!
    @State var alert : Bool = false
    
    var body: some View {
            List{
                ForEach(postsToPrint) { post in
                    PostView(post: post,
                             estUnCommentaire: false,
                             aimer: post.reactions.contains(self.appState.utilisateur.id),
                             signaler: self.appState.estSignaler(postOuComment: post),
                             size: 45)
                }.onDelete(perform: {
                    let index = Array($0)
                         let post = self.appState.posts[index[0]]
                         if(self.appState.utilisateur.id == post.createur._id){
                             self.appState.supprimerComOuPost(post: post)
                             self.appState.posts.remove(atOffsets: $0)
                         }else{
                             self.alert.toggle()
                         }
                    }).alert(isPresented: self.$alert, content: {
                     Alert(title: Text("Supprimer"), message: Text("Désolé vous n'avez pas le droit de supprimer d'autres posts à part les votres."), dismissButton: .default(Text("Ok"), action: { self.alert.toggle() }))
                    })
            }
    }
}

