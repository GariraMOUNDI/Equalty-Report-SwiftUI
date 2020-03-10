//
//  CommentaireView.swift
//  Projet AWI - Mobile
//
//  Created by user165586 on 26/02/2020.
//  Copyright © 2020 Remy McConnell. All rights reserved.
//

import SwiftUI

struct CommentaireView: View {
    @EnvironmentObject var appState : AppState
    @State var post: Post
    @State var commentaire : String
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Commentaires") .fontWeight(.medium).bold().font(.largeTitle).padding(.top, 20).padding(.leading, 20)
            
            PostView(post: post,
                 commentaire: Commentaire(),
                 estUnCommentaire: false,
                 aimer: self.post.reactions.contains(self.appState.utilisateur.id),
                signaler: self.appState.estSignaler(post: post),
                comment: true, size: 40).padding(.horizontal, 20)
            
            List{
               ForEach(self.appState.commentaires) { commentaire in
                PostView(post: Post(), commentaire: commentaire, estUnCommentaire: true, aimer: commentaire.reactions.contains(self.appState.utilisateur.id), signaler: self.appState.estSignaler(post: commentaire),comment: true, size: 30)
                }
                HStack{
                    TextField("Commenter", text: self.$commentaire)
                        .padding(20)
                            .frame(height: 40.0)
                            .background(Color(red: 211/255, green: 211/255, blue: 211/255, opacity: 1))
                        .cornerRadius(10)
                    Button(action: {
                        // A coder la logique
                    }){
                        Image(systemName: "tray.and.arrow.up.fill")
                            .font(.system(size: 25)).foregroundColor(Color.blue)
                    }.onTapGesture {
                        self.appState.creerCommentaireOuPost(createur:
                            self.appState.utilisateur.id, parentId: self.post.id, texte: self.commentaire)
                        self.commentaire = ""
                    }
                }
            }
                
        }
            
    }
}

/*struct CommentaireView_Previews: PreviewProvider {
    static var previews: some View {
        CommentaireView(post: Post(id: 0, texte: "MOI",createur: "",
                                   commentaires: [Post(id: 0, texte: "Commentaire",createur: "", commentaires: [])]), commentaire: "")
    }
}
*/
