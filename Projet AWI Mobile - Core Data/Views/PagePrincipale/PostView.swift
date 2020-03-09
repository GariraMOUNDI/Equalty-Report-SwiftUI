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
    var post : Post
    var commentaire : Commentaire
    var estUnCommentaire : Bool
    
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
    var body: some View {
        VStack(alignment : mode){
            HStack(alignment: .top){
                if (imgGauche){
                    Image("Flame").resizable().frame(width: 40.0, height: 40.0).cornerRadius(10)
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
                    Image("Flame").resizable().frame(width: 40.0, height: 40.0).cornerRadius(10)
                }
            }
            
            if(self.appState.isConnected){
                HStack(){
                    Spacer()
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                        HStack{
                           Image(systemName: "hand.thumbsup").foregroundColor(Color.blue)
                            if(estUnCommentaire){
                                Text("\(commentaire.reactions.count)").foregroundColor(Color.blue)
                            }else{
                                Text("\(post.reactions.count)").foregroundColor(Color.blue)
                            }
                        }
                        
                    }.onTapGesture {
                        print("J'aime")
                    }
                    Spacer()
                    
                    if(!comment){
                        Button(action: {
                            self.com = true
                            self.appState.getCommentaires(parentId : self.post.id)
                        }){
                            Image(systemName: "message.circle").foregroundColor(Color.blue)
                        }.sheet(isPresented: self.$com , onDismiss: {
                            self.com = false
                        }, content: {
                            CommentaireView(post: self.post, commentaire: "").environmentObject(self.appState)
                        })
                    }
                    Spacer()
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                        Image(systemName: "exclamationmark.triangle").foregroundColor(Color.blue)
                    }.onTapGesture {
                        print("Signaler")
                    }
                    Spacer()
                }
            }
        }
    }
}

/*struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: Post(id: 0, texte: "MOI",createur: "", commentaires:[]), com: true)
    }
}
 */
