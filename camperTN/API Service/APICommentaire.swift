//
//  APICommentaire.swift
//  camperTN
//
//  Created by chekir walid on 10/12/2021.
//

import Foundation

class APICommentaire: NSObject {
    func getAllCommentaireShareEvents(idEvent: String,completion : @escaping ([CommentaireData]) -> ()){
        guard let url = URL(string: "\(baseURL)/commentaires/\(idEvent)") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else{
                print("error !")
                return
            }
            guard let shareEventData = try? JSONDecoder().decode([CommentaireData].self, from: data) else{
                print("no data event")
                return
            }
            completion(shareEventData)
        }.resume()
    }
    
    func createCommentaire(commentaire: Commentaire, completion: @escaping(Error?) -> () ){
        guard let url = URL(string: "\(baseURL)/commentaires/create") else { return }
        do {
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(commentaire)
            
            print(commentaire)
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                      let jsonData = data else{
                          print("failed")
                          completion(error)
                          return
                      }
                do {
                    let messageData = try JSONDecoder().decode(Commentaire.self, from: jsonData)
                    print("success => \(messageData)")
                    completion(nil)
                }catch{
                    print("failed")
                    completion(error)
                }
            }.resume()
        }catch{
            print("failed")
            completion(error)
        }
    }
}
