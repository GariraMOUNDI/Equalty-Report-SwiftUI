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
    @Published var photos : [String] = []
    
    func getPost(){
        let url = URL(string: "http://project-awi-api.herokuapp.com/posts")!
        
        URLSession.shared.dataTask(with: url){data,_,_  in
            if let data = data {
                print(data)
                if let posts = try? JSONDecoder().decode([Post].self, from: data) {
                    DispatchQueue.main.async {
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
    func supprimerComOuPost(post: Any){
        let chemin : String
        let id : String
        
        if let post = post as? Post {
            chemin = "posts"
            id = post.id
        }else{
            let commentaire = post as! Commentaire
            chemin = "commentaires"
            id = commentaire.id
        }
        
        let url = URL(string: "http://project-awi-api.herokuapp.com/\(chemin)/\(id)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(self.utilisateur.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        URLSession.shared.dataTask(with: request).resume()
        
        if let commentaire = post as? Commentaire {
            var newPosts: [Post] = []
            posts.forEach{ post in
                if( post.id == commentaire.parentId){
                    post.numCommentaires = post.numCommentaires - 1
                    newPosts.append(post)
                }else{
                    newPosts.append(post)
                }
            }
            self.posts = newPosts
        }
    }
    
    // Permet de creer un commentaire
    func creerCommentaireOuPost(createur: String, parentId: String, texte: String){
        let chemin: String
        let body : [String : String]
        if(parentId == ""){
            chemin = "posts"
            body = ["createur" : createur, "texte": texte, "dateCreation": Date().description]
        }else{
            chemin = "commentaires"
            body = ["createur" : createur, "parentId" : parentId, "texte": texte, "dateCreation": Date().description]
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
                                    self.commentaires.insert(commentaire, at: 0)
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
                "reactions": postToModify.reactions,
                "signaler": postToModify.signaler
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
            
            let body : [String : Any] = ["createur" : ["_id" : commentaireToModify.createur._id, "pseudo": commentaireToModify.createur.pseudo] , "texte": commentaireToModify.texte, "id": commentaireToModify.id, "dateCreation": commentaireToModify.dateCreation, "reactions": commentaireToModify.reactions, "signaler" : commentaireToModify.signaler ]
            
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
    
    func checkExistance(pseudo : String){
        
    }
    
    func setUtilisateur(_ pseudo: String, _ mdp : String, _ email: String, _ photo: String){
        let utilisateur = Utilisateur(token: self.utilisateur.token, data: Data(_id: self.utilisateur.id, pseudo: pseudo, email: email, isAdmin: self.utilisateur.data.isAdmin, photo: photo))
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
    
    func requeteUtilisateur(pseudo:String = "", mdp: String = "", email: String = "", photo: String = "", type: Crud){
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
            body = ["pseudo" : pseudo, "mdp" : mdp, "email": email, "photo": photo]
            withToken = false
            break
        case .Modifier:
            method = "PATCH"
            chemin = "utilisateurs/\(self.utilisateur.id)"
            body = [
                "pseudo" : pseudo,
                "email" : email,
                "mdp" : mdp,
                "isAdmin": utilisateur.data.isAdmin!,
                "photo": photo
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
        print(body)
        let url = URL(string: "http://project-awi-api.herokuapp.com/\(chemin)")!
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
                if let utilisateur = try? JSONDecoder().decode(Utilisateur.self, from: data) {
                    DispatchQueue.main.async {
                        self.utilisateur = utilisateur
                    }
                    return
                }else{
                    if(type == .Modifier){
                        self.setUtilisateur(pseudo, mdp, email, photo)
                    }else{
                        DispatchQueue.main.async {
                            if(type == .Supprimer){
                                self.isConnected = false
                                self.getPost()
                            }
                            self.utilisateur = Utilisateur()
                            print("Cannot parse the result to Utilisateur !!!")
                        }
                    }
                }
            }
            print("Erreur")
        }.resume()
    }
    
    func downloadPhotos(number: Int){
        for i in 1...number {
            photos.append("img\(i)")
        }
    }
}

