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
    
    var body: some View {
        List{
            ForEach(postsToPrint) { post in
                PostView(post: post, commentaire: Commentaire(),
                         estUnCommentaire: false,
                         aimer: post.reactions.contains(self.appState.utilisateur.id),
                         signaler: self.appState.estSignaler(post: post),
                         size: 40)
            }.onDelete(perform: {
                // if faut aussi le supprimer de la base de données
                self.appState.posts.remove(atOffsets: $0)
                
            })
        }
     }
}
/*
struct ListPostView_Previews: PreviewProvider {
    static var previews: some View {
        ListPostView(samplePosts: [Post(id: 0, texte: "Moi",createur: "", commentaires: []), Post(id: 0, texte: "Toi",createur: "", commentaires: [])])
    }
}
*/
