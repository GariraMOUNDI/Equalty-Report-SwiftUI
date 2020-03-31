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
    @State var post : Post! = nil
    @State var commentaire : Commentaire! = nil
    var estUnCommentaire : Bool
    @State var texteSignaler : String = ""
    @State var aimer: Bool
    @State var signaler : Bool
    @State var com : Bool = false
    @State var postBouton : Bool = false
    var comment : Bool = false
    var couleurGauche : Color {
        get {
            if(self.post != nil){
                if(self.post.createur._id != self.appState.utilisateur.id){
                    return Color(red: 93/255, green: 93/255, blue: 187/255)
                }else{
                    return Color(red: 219/255, green: 221/255, blue: 255/255)
                }
            }else{
                if(self.commentaire.createur._id != self.appState.utilisateur.id){
                    return Color(red: 93/255, green: 93/255, blue: 187/255)
                }else{
                    return Color(red: 219/255, green: 221/255, blue: 255/255)
                }
            }
            
        }
    }
    var couleurDroite : Color {
        get{
            if(self.post != nil){
                if(self.post.createur._id != self.appState.utilisateur.id){
                    return Color(red: 219/255, green: 221/255, blue: 255/255)
                }else{
                    return Color(red: 120/255, green: 93/255, blue: 187/255)
                }
            }else{
                if(self.commentaire.createur._id != self.appState.utilisateur.id){
                    return Color(red: 219/255, green: 221/255, blue: 255/255)
                }else{
                    return Color(red: 120/255, green: 93/255, blue: 187/255)
                }
            }
        }
    }
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
                    if(self.post != nil){
                        Image(self.post.createur.photo).resizable().frame(width: size, height: size).clipShape(Circle()).shadow(radius: 5)
                    }else{
                        Image(self.commentaire.createur.photo).resizable().frame(width: size, height: size).clipShape(Circle()).shadow(radius: 5)
                    }
                }
                if (imgDroite){
                    Spacer()
                }
                
                VStack(alignment: mode){
                    if(estUnCommentaire){
                        HStack{
                            if(self.imgDroite){
                                Text(commentaire.date).font(.system(size: 10))
                                Spacer()
                            }
                            Text(commentaire.createur.pseudo).bold()
                            if(imgGauche){
                                Spacer()
                                Text(commentaire.date).font(.system(size: 10))
                            }
                        }
                        Text(commentaire.texte).lineLimit(nil)
                    }else{
                        HStack{
                            Text(post.createur.pseudo).bold()
                            Spacer()
                            Text(post.date).font(.system(size: 10))
                        }
                        Text(post.texte).lineLimit(nil)
                    }
                }.shadow(radius: 1,y:1)
                
                if (imgDroite){
                    Image(self.commentaire.createur.photo).resizable().frame(width: size, height: size).clipShape(Circle()).shadow(radius: 5)
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
                        }){
                            Image(systemName: "message.circle").foregroundColor(Color.blue)
                        }.sheet(isPresented: self.$com , onDismiss: {
                            self.com = false
                            self.appState.commentaires = []
                        }, content: {
                            CommentaireView(post: self.post, commentaire: "").environmentObject(self.appState)
                        })
                        Text("\(self.post.numCommentaires)").foregroundColor(Color.blue)
                    }
                    
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "exclamationmark.triangle").foregroundColor(signaler ? Color.red : Color.blue)
                    }.onTapGesture{
                        if(self.signaler){
                            self.signaler = false
                            self.signalerPost(texte: "")
                        }else{
                            self.postBouton.toggle()
                        }
                    }.sheet(isPresented: self.$postBouton,
                            onDismiss: {
                                self.postBouton = false
                                self.signalerPost(texte: self.texteSignaler)
                    },
                            content: {
                                EcrirePostView(texte: self.$texteSignaler, postBouton: self.$postBouton, changerCouleur: self.$signaler, signaler: true)
                            })
                    Spacer()
                }
            }
        }.padding(5)
        .background(LinearGradient(gradient: Gradient(colors: [self.couleurGauche, self.couleurDroite]),startPoint: .leading,endPoint: .trailing))
        .cornerRadius(10)
    }
    
    func aimerPost(){
        self.aimer.toggle()
        if(self.estUnCommentaire){
            
            if(self.aimer){
                self.commentaire.reactions.append(self.appState.utilisateur.id)
            }else{
                self.commentaire.reactions = self.commentaire.reactions.filter({
                    return $0 != self.appState.utilisateur.id
                })
            }
            self.appState.ajouterLike(postToModify: self.commentaire!)
        }else{
            if(self.aimer){
                self.post.reactions.append(self.appState.utilisateur.id)
            }else{
                self.post.reactions = self.post.reactions.filter({
                    return $0 != self.appState.utilisateur.id
                })
            }
            self.appState.ajouterLike(postToModify: self.post!)
        }
    }
    
    func signalerPost(texte : String){
        if(self.estUnCommentaire){
            if(self.signaler){
                self.commentaire.signaler.append(Signaler(_id : self.appState.utilisateur.id, texte: texte))
            }else{
                self.commentaire.signaler = self.commentaire.signaler.filter({
                    return $0._id != self.appState.utilisateur.id
                })
            }
           self.appState.signalerPost(postToModify: self.commentaire!)
        }else{
            if(self.signaler){
                self.post.signaler.append(Signaler(_id : self.appState.utilisateur.id, texte: texte))
            }else{
                self.post.signaler = self.post.signaler.filter({
                    return $0._id != self.appState.utilisateur.id
                })
            }
           self.appState.signalerPost(postToModify: self.post!)
        }
    }
}
