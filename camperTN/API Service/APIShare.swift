//
//  APIShare.swift
//  camperTN
//
//  Created by chekir walid on 9/12/2021.
//

import Foundation

class APIShare: NSObject{
    func getShareEvents(completion : @escaping ([shareEventData]) -> ()){
        guard let url = URL(string: "\(baseURL)/shares") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else{
                print("error !")
                return
            }
            guard let shareEventData = try? JSONDecoder().decode([shareEventData].self, from: data) else{
                print("no data event")
                return
            }
            completion(shareEventData)
        }.resume()
    }
    
    func createShare(share: shareEvent, completion: @escaping(Error?) -> ()){
        guard let url = URL(string: "\(baseURL)/shares/create") else { return }
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(share)
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                      let jsonData = data else{
                          print("failed")
                          completion(error)
                          return
                      }
                do {
                    let messageData = try JSONDecoder().decode(shareEvent.self, from: jsonData)
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
    
    func updateLikeDislike(share: ShareDataUpdate, completion: @escaping(Error?) -> () ){
        guard let url = URL(string: "\(baseURL)/shares/LikeOrUnlike/\(share._id)/\(share.emailcampeur)") else { return }
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "PATCH"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(share)
            
            print(share)
            print(try JSONEncoder().encode(share))
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let err = error {
                    print(err)
                }
            }.resume()
        }catch{
            print("failed")
            completion(error)
        }
    }
    
    func countLikeAndReturnIsliked(share: ShareDataUpdate,completion : @escaping (likeData) -> ()){
        guard let url = URL(string: "\(baseURL)/shares/likeReturnData/\(share._id)/\(share.emailcampeur)") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else{
                print("error !")
                return
            }
            guard let emailExist = try? JSONDecoder().decode(likeData.self, from: data) else{
                print("no data event")
                return
            }
            completion(emailExist)
        }.resume()
    }
    
}
