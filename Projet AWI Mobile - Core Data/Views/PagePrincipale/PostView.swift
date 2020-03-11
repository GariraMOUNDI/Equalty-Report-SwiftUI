//
//  PostView.swift
//  Projet AWI - Mobile
//
//  Created by user165586 on 26/02/2020.
//  Copyright © 2020 Remy McConnell. All rights reserved.
//

import SwiftUI

struct PostView: View {
    @EnvironmentObject var appState : AppState
    @State var post : Post
    @State var commentaire : Commentaire
    var estUnCommentaire : Bool
    @State var aimer: Bool
    @State var signaler : Bool
    @State var com : Bool = false
    var comment : Bool = false
    
    var imgGauche : Bool{
        get{
            if(estUnCommentaire){
                if(self.appState.utilisateur.id == self.commentaire.createur._id){
                    return false
                }else{
                    return true
                }
            }else{
               return true
            }
        }
    }
    var  imgDroite : Bool {
        get{
            if(estUnCommentaire){
                if(self.appState.utilisateur.id == self.commentaire.createur._id){
                    return true
                }else{
                    return false
                }
            }else{
               return false
            }
        }
    }
    var mode : HorizontalAlignment {
        get{
            if (imgGauche){
                return .leading
            }else {
                return .trailing
            }
        }
    }
    var size : CGFloat
    
    var body: some View {
        VStack(alignment : mode){
            HStack(alignment: .top){
                if (imgGauche){
                    Image("Flame").resizable().frame(width: size, height: size).cornerRadius(10)
                }
                if (imgDroite){
                    Spacer()
                }
                VStack(alignment: mode){
                    if(estUnCommentaire){
                        Text(commentaire.createur.pseudo).bold()
                        Text(commentaire.texte)
                    }else{
                        Text(post.createur.pseudo).bold()
                        Text(post.texte)
                    }
                }.shadow(radius: 1,y:1)
                if (imgDroite){
                    Image("Flame").resizable().frame(width: size, height: size).cornerRadius(10)
                }
            }
            
            if(self.appState.isConnected){
                HStack(){
                    Spacer()
                    Button(action: {}) {
                        HStack{
                            if(estUnCommentaire){
                                if (aimer){
                                    Image(systemName: "hand.thumbsup.fill").foregroundColor(Color.red)
                                    Text("\(commentaire.reactions.count)").foregroundColor(Color.red)
                                }else{
                                    Image(systemName: "hand.thumbsup").foregroundColor(Color.blue)
                                    Text("\(commentaire.reactions.count)").foregroundColor(Color.blue)
                                }
                            }else{
                                if (aimer){
                                    Image(systemName: "hand.thumbsup.fill").foregroundColor(Color.red)
                                    Text("\(post.reactions.count)").foregroundColor(Color.red)
                                }else{
                                    Image(systemName: "hand.thumbsup").foregroundColor(Color.blue)
                                    Text("\(post.reactions.count)").foregroundColor(Color.blue)
                                }
                            }
                        }
                    }.onTapGesture {
                        self.aimerPost()
                    }
                    Spacer()
                    
                    if(!comment){
                        Button(action: {
                            self.com = true
                            self.appState.getCommentaires(parentId : self.post.id)
                        }){                            Image(systemName: "message.circle").foregroundColor(Color.blue)
                        }.sheet(isPresented: self.$com , onDismiss: {
                            self.com = false
                            self.appState.commentaires = []
                            //self.appState.getPost()
                        }, content: {
                            CommentaireView(post: self.post, commentaire: "").environmentObject(self.appState)
                        })
                        Text("\(self.post.numCommentaires)").foregroundColor(Color.blue)
                    }
                    
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "exclamationmark.triangle").foregroundColor(signaler ? Color.red : Color.blue)
                    }.onTapGesture{
                        self.signalerPost()
                    }
                    Spacer()
                }
            }
        }
        
    }
    
    func aimerPost(){
        if(self.estUnCommentaire){
            self.aimer.toggle()
            if(self.aimer){
                self.commentaire.reactions.append(self.appState.utilisateur.id)
            }else{
                self.commentaire.reactions = self.commentaire.reactions.filter({
                    return $0 != self.appState.utilisateur.id
                })
            }
            self.appState.ajouterLike(postToModify: self.commentaire)
        }else{
            self.aimer.toggle()
            if(self.aimer){
                self.post.reactions.append(self.appState.utilisateur.id)
            }else{
                self.post.reactions = self.post.reactions.filter({
                    return $0 != self.appState.utilisateur.id
                })
            }
            self.appState.ajouterLike(postToModify: self.post)
        }
    }
    
    func signalerPost(){
        self.signaler = true
        if (self.estUnCommentaire){
            self.commentaire.signaler.append(
                Signaler(createur: self.appState.utilisateur.id, texte: "Un texte")
            )
        }else{
            self.post.signaler.append(
                Signaler(createur: self.appState.utilisateur.id, texte: "Un texte")
            )
        }
        let elementModifier : Any = self.estUnCommentaire ? self.commentaire : self.post
        // Il faut l'en registrer dans la base de données
        self.appState.signalerPost(postToModify: elementModifier)
    }
}

/*struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: Post(id: 0, texte: "MOI",createur: "", commentaires:[]), com: true)
    }
}
 */
