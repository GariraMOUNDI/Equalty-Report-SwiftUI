//
//  File.swift
//  Projet AWI - Mobile
//
//  Created by user165586 on 28/02/2020.
//  Copyright © 2020 Remy McConnell. All rights reserved.
//

import Foundation

class AppState : ObservableObject {
    @Published var isConnected : Bool = false
    @Published var posts : [Post] = []
    @Published var utilisateur = Utilisateur(token: "", data: Data(_id: "", pseudo: "", email: ""))
    @Published var modifierUtilisateur : Bool = false
    @Published var commentaires : [Commentaire] = []
    
    func getPost(){
        let url = URL(string: "http://project-awi-api.herokuapp.com/posts")!
        
        URLSession.shared.dataTask(with: url){data,_,_  in
            if let data = data {
                if let posts = try? JSONDecoder().decode([Post].self, from: data) {
                    DispatchQueue.main.async {
                        print(posts[0].id)
                        self.posts = posts
                    }
                    return
                }else{
                    print("No data posts !!!")
                }
            }
            print("Erreur !!!")
        }.resume()

    }
    
    // Permet de recuperer tous les utilisateurs
    func getUtilisateur(_ pseudo: String, _ mdp : String){
        let url = URL(string: "http://project-awi-api.herokuapp.com/auth")!
        
        let body : [String : String] = ["pseudo" : pseudo, "mdp" : mdp]
        print(body)
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpBody = finalBody
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        URLSession.shared.dataTask(with: request){data,_,_  in
            if let data = data {
                print(data)
                if let utilisateur = try? JSONDecoder().decode(Utilisateur.self, from: data) {
                   DispatchQueue.main.async {
                        self.utilisateur = utilisateur
                    }
                        return
                }else{
                    print("No data !!!")
                }
            }
        print("Erreur !!!")
        }.resume()
         
    }
    
    // Permet de recuperer tous les commentaires
    func getCommentaires(parentId : String) -> [Commentaire]{
        let url = URL(string: "http://project-awi-api.herokuapp.com/commentaires/\(parentId)")!
        
        URLSession.shared.dataTask(with: url){data,_,_  in
            if let data = data {
                if let commentaires = try? JSONDecoder().decode([Commentaire].self, from: data) {
                    DispatchQueue.main.async {
                        self.commentaires = commentaires
                    }
                    return
                }else{
                    print("No data commentaires !!!")
                }
            }
            print("Erreur commentaires !!!")
        }.resume()
    return []
    }
    
    // Permet de creer un commentaire
    func creerCommentaire(createur: String, parentId: String, texte: String){
        let url = URL(string: "http://project-awi-api.herokuapp.com/commentaires")!
        
        let body : [String : String] = ["createur" : createur, "parentId" : parentId, "texte": texte]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpBody = finalBody
        request.httpMethod = "POST"
        request.setValue("Bearer \(self.utilisateur.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        URLSession.shared.dataTask(with: request){data,_,_  in
            if let data = data {
                print(data)
                if let comment = try? JSONDecoder().decode(Commentaire.self, from: data) {
                   DispatchQueue.main.async {
                        print(comment)
                        self.commentaires.append(comment)
                    }
                        return
                }else{
                    print("Echec de création commentaire !!!")
                }
            }
        print("Erreur !!!")
            return
        }.resume()
        
        
        var newPosts: [Post] = []
        posts.forEach{ post in
            if( post.id == parentId){
                post.numCommentaires = post.numCommentaires + 1
                newPosts.append(post)
            }else{
                newPosts.append(post)
            }
        }
        self.posts = newPosts
    }
    
    func ajouterLike(postToModify: Any){
        
        if let postToModify = postToModify as? Post{
            // Enregistrement dans la base de données
            let url = URL(string: "http://project-awi-api.herokuapp.com/posts/\(postToModify.id)")!
            
            let body : [String : Any] = ["createur" : ["_id" : postToModify.createur._id, "pseudo": postToModify.createur.pseudo] , "texte": postToModify.texte, "id": postToModify.id, "dateCreation": postToModify.dateCreation, "reactions": postToModify.reactions]
            
            let finalBody = try! JSONSerialization.data(withJSONObject: body)
            
            var request = URLRequest(url: url)
            request.httpBody = finalBody
            request.httpMethod = "PATCH"
            request.setValue("Bearer \(self.utilisateur.token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-type")
            
            URLSession.shared.dataTask(with: request){data,_,_  in
                if let data = data {
                     print(data)
             }
            }.resume()
            
            
            // Modification de la vue
            var newPosts: [Post] = []
            posts.forEach{ post in
                if( postToModify.id == post.id ){
                    newPosts.append(postToModify)
                }else{
                    newPosts.append(post)
                }
            }
            self.posts = newPosts
        }else{
            let commentaireToModify = postToModify as! Commentaire
            
            //Enregistrement dans la base de données
            
            // à coder
            
            // Modification de la vue
            var newCommentaire: [Commentaire] = []
            commentaires.forEach{ commentaire in
                if( commentaireToModify.id == commentaire.id ){
                    newCommentaire.append(commentaireToModify)
                }else{
                    newCommentaire.append(commentaire)
                }
            }
            self.commentaires = newCommentaire
        }
    }
    
    func rafraichirCommentaire(){
        var newCommentaire: [Commentaire] = []
        commentaires.forEach{ commentaire in
           newCommentaire.append(commentaire)
        }
        self.commentaires = newCommentaire
    }
}
