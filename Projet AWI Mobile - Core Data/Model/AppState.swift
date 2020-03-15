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
    @Published var utilisateur = Utilisateur()
    @Published var modifierUtilisateur : Bool = false
    @Published var commentaires : [Commentaire] = []
    
    func getPost(){
        let url = URL(string: "http://project-awi-api.herokuapp.com/posts")!
        
        URLSession.shared.dataTask(with: url){data,_,_  in
            if let data = data {
                print(data)
                if let posts = try? JSONDecoder().decode([Post].self, from: data) {
                    DispatchQueue.main.async {
                        print(posts[0].id)
                        self.posts = posts
                        print(Date())
                    }
                    return
                }else{
                    print("No data posts !!!")
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
    
    // Permet de supprimer un post ou commentaire
//    func supprimerCommentaire(post: Any){
//        var chemin : String
//        if let post = post as? Post {
//            
//        }
//    }
    
    // Permet de creer un commentaire
    func creerCommentaireOuPost(createur: String, parentId: String, texte: String){
        let chemin: String
        let body : [String : String]
        if(parentId == ""){
            chemin = "posts"
            body = ["createur" : createur, "texte": texte]
        }else{
            chemin = "commentaires"
            body = ["createur" : createur, "parentId" : parentId, "texte": texte]
        }
        
        let url = URL(string: "http://project-awi-api.herokuapp.com/\(chemin)")!
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpBody = finalBody
        request.httpMethod = "POST"
        request.setValue("Bearer \(self.utilisateur.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        URLSession.shared.dataTask(with: request){data,_,_  in
                if let data = data {
                    print(data)
                    if(parentId == ""){
                        if let post = try? JSONDecoder().decode(Post.self, from: data) {
                            DispatchQueue.main.async {
                                 self.posts.insert(post, at: 0)
                             }
                                return
                        }else{
                            print("Echec de création de post !!!")
                        }
                    }else{
                        if let commentaire = try? JSONDecoder().decode(Commentaire.self, from: data) {
                            DispatchQueue.main.async {
                                    self.commentaires.append(commentaire)
                            }
                                return
                        }else{
                            print("Echec de création de commentaire !!!")
                        }
                    }
                }else{
                    print("Pas de commentaire ou post !!!")
                }
            print("Erreur !!!")
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
    
    // permet d'ajouter un like
    func ajouterLike(postToModify: Any){
        if let postToModify = postToModify as? Post{
            // Enregistrement dans la base de données
            let url = URL(string: "http://project-awi-api.herokuapp.com/posts/\(postToModify.id)")!
            
            let body : [String : Any] = [
                "createur" :
                    ["_id" : postToModify.createur._id,
                     "pseudo": postToModify.createur.pseudo] ,
                "texte": postToModify.texte, "id": postToModify.id,
                "dateCreation": postToModify.dateCreation,
                "reactions": postToModify.reactions
            ]
            
            let finalBody = try! JSONSerialization.data(withJSONObject: body)
            
            var request = URLRequest(url: url)
            request.httpBody = finalBody
            request.httpMethod = "PATCH"
            request.setValue("Bearer \(self.utilisateur.token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-type")
            
            URLSession.shared.dataTask(with: request).resume()
            
            // Modification de la vue
            self.rafraichirPost(postToModify: postToModify)
        }else{
            let commentaireToModify = postToModify as! Commentaire
            //Enregistrement dans la base de données
            let url = URL(string: "http://project-awi-api.herokuapp.com/commentaires/\(commentaireToModify.id)")!
            
            let body : [String : Any] = ["createur" : ["_id" : commentaireToModify.createur._id, "pseudo": commentaireToModify.createur.pseudo] , "texte": commentaireToModify.texte, "id": commentaireToModify.id, "dateCreation": commentaireToModify.dateCreation, "reactions": commentaireToModify.reactions]
            
            let finalBody = try! JSONSerialization.data(withJSONObject: body)
            
            var request = URLRequest(url: url)
            request.httpBody = finalBody
            request.httpMethod = "PATCH"
            request.setValue("Bearer \(self.utilisateur.token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-type")
            
            URLSession.shared.dataTask(with: request).resume()
            
            // Modification de la vue
            self.rafraichirCommentaire(commentaireToModify: commentaireToModify)
        }
    }
    
    func setUtilisateur(_ pseudo: String, _ mdp : String, _ email: String){
        let utilisateur = Utilisateur(token: self.utilisateur.token, data: Data(_id: self.utilisateur.id, pseudo: pseudo, email: email, isAdmin: self.utilisateur.data.isAdmin))
        self.utilisateur = utilisateur
    }
    
    func estSignaler(post: Any) -> Bool{
        var number : Int
        if let post = post as? Post {
            number = post.signaler.count
        }else{
            let commentaire = post as! Commentaire
            number = commentaire.signaler.count
        }
        if (number == 0){
            return false
        }else{
            return true
        }
    }
    
    func signalerPost(postToModify: Any){
        self.ajouterLike(postToModify: postToModify)
    }
    
    func rafraichirPost(postToModify: Post){
        var newPosts: [Post] = []
        posts.forEach{ post in
            if( post.id == postToModify.id ){
                newPosts.append(postToModify)
            }else{
                newPosts.append(post)
            }
        }
        self.posts = newPosts
    }
    
    func rafraichirCommentaire(commentaireToModify: Commentaire){
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
    
    public enum Crud{
        case Lire, Creer, Modifier, Supprimer
    }
    
    func requeteUtilisateur(_ pseudo:String = "", _ mdp: String = "", _ email: String = "", type: Crud){
        var chemin : String = ""
        var method : String = ""
        var withToken : Bool = false
        var body : [String : Any] = [:]
        
        switch type {
        case .Lire:
            method = "POST"
            chemin = "auth/login"
            body = ["pseudo" : pseudo, "mdp" : mdp]
            withToken = false
            break
        case .Creer:
            method = "POST"
            chemin = "auth/createaccount"
            body = ["pseudo" : pseudo, "mdp" : mdp, "email": email]
            withToken = false
            break
        case .Modifier:
            method = "PATCH"
            chemin = "utilisateurs/\(self.utilisateur.id)"
            body = [
                "pseudo" : pseudo,
                "email" : email,
                "mdp" : mdp,
                "isAdmin": utilisateur.data.isAdmin!
            ]
            withToken = true
            break
        case .Supprimer:
            method = "DELETE"
            chemin = "utilisateurs/\(self.utilisateur.id)"
            body = [:]
            withToken = true
            break
        }
        
        let url = URL(string: "http://project-awi-api.herokuapp.com/\(chemin)")!
        print(body)
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpBody = finalBody
        request.httpMethod = method
        if(withToken){
            request.setValue("Bearer \(self.utilisateur.token)", forHTTPHeaderField: "Authorization")
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        URLSession.shared.dataTask(with: request){data,_,_  in
            if let data = data {
                print(data)
                if let utilisateur = try? JSONDecoder().decode(Utilisateur.self, from: data) {
                    DispatchQueue.main.async {
                        print(utilisateur.data.pseudo)
                        self.utilisateur = utilisateur
                    }
                    return
                }else{
                    if(type == .Modifier){
                        self.setUtilisateur(pseudo, mdp, email)
                    }else{
                        DispatchQueue.main.async {
                            self.utilisateur = Utilisateur()
                            print("Cannot parse the result to Utilisateur !!!")
                        }
                    }
                }
            }
            print("Erreur")
        }.resume()
    }
}

