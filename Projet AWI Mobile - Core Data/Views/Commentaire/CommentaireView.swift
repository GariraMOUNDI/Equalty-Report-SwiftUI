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
    @State var alert : Bool = false
    @State var value : CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Commentaires") .fontWeight(.medium).bold().font(.largeTitle).padding(.top, 20).padding(.leading, 20)
            
            PostView(post: post,
                 estUnCommentaire: false,
                 aimer: self.post.reactions.contains(self.appState.utilisateur.id),
                signaler: self.appState.estSignaler(post: post),
                comment: true, size: 45).padding(.horizontal, 20)
            
            List{
               ForEach(self.appState.commentaires) { commentaire in
                PostView(commentaire: commentaire, estUnCommentaire: true, aimer: commentaire.reactions.contains(self.appState.utilisateur.id),
                         signaler: self.appState.estSignaler(post: commentaire),comment: true, size: 30)
                    
               }.onDelete(perform: {
                    let index = Array($0)
                    let com = self.appState.commentaires[index[0]]
                    if(self.appState.utilisateur.id == com.createur._id){
                        self.appState.supprimerComOuPost(post: com)
                        self.appState.commentaires.remove(atOffsets: $0)
                    }else{
                        self.alert.toggle()
                    }
               }).alert(isPresented: self.$alert, content: {
                Alert(title: Text("Supprimer"), message: Text("Désolé vous n'avez pas le droit de supprimer d'autres commentaires à part les votres."), dismissButton: .default(Text("Ok"), action: { self.alert.toggle() }))
               })
            }
            
            HStack{
                TextView(placeholderText: "Commenter ...", text: self.$commentaire).frame(numLines: 2).cornerRadius(20)
                BoutonCommenter(commentaire: self.$commentaire, post: self.$post)
            }.padding(.horizontal, 10)
            .offset(y: -self.value)
            .onAppear{
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main){ noti in
                        let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                        self.value = value.size.height
                        print(self.value)
                }
                    
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main){ noti in
                        self.value = 0
                    }
            }
                
        }
            
    }
}

struct BoutonCommenter : View {
    
    @EnvironmentObject var appState : AppState
    @Binding var commentaire : String
    @Binding var post : Post
    
    var body : some View {
        ZStack{
            Circle().foregroundColor(.white).frame(width: 35, height: 35)
            Button(action: {
                self.appState.creerCommentaireOuPost(createur: self.appState.utilisateur.id, parentId: self.post.id, texte: self.commentaire)
                self.commentaire = ""
                UIApplication.shared.keyWindow?.endEditing(true)
            }){
                Image(systemName: "tray.and.arrow.up.fill")
                    .font(.system(size: 25)).foregroundColor(Color.blue)
            }
        }
        
    }
}
