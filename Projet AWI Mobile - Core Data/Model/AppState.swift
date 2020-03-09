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
    
    func configureState(isConnected : Bool){
        self.isConnected = isConnected
        self.parsePost{
            /*
            for p in $0 {
                self.posts.append(p)
            }*/
            self.posts = $0
        }
        self.parseUtilisateur()
    }

    func parsePost(completion: @escaping ([Post]) -> ()){
        
        let url = URL(string: "http://project-awi-api.herokuapp.com/posts")!
        
        URLSession.shared.dataTask(with: url){data,_,_  in
            if let data = data {
                if let posts = try? JSONDecoder().decode([Post].self, from: data) {
                    DispatchQueue.main.async {
                        completion(posts)
                    }
                    return
                }else{
                    print("No data !!!")
                }
            }
            print("Erreur !!!")
        }.resume()

    }
    
    func parseUtilisateur() {
         /*
          url = URL(string: "http://project-awi-api.herokuapp.com/"Chemin")!
         
         URLSession.shared.dataTask(with: url){data,_,_  in
             if let data = data {
                self.posts = try! JSONDecoder().decode([Post].self, from: data)
             }
             print(self.posts ?? "No data")
         }.resume()
          */
         
        //self.utilisateur = Utilisateur(id: " ", data: Data())
         // print(self.utilisateur!)
     }
    
    func getUtilisateur(_ pseudo: String, _ mdp : String){
        let url = URL(string: "http://project-awi-api.herokuapp.com/auth")!
        
        let body : [String : String] = ["pseudo" : pseudo, "mdp" : mdp]
        print(body)
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        // Créer un fichier JSON
//        if let file = FileHandle(forWritingAtPath: ){
//            file.write(finalBody)
//        }
        
        
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
}
