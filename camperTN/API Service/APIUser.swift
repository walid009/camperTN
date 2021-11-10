//
//  APIUser.swift
//  camperTN
//
//  Created by chekir walid on 9/11/2021.
//

import Foundation

class APIUser: NSObject{
    
    func getUser(email: String,completion : @escaping (UserInfo) -> ()){
        guard let url = URL(string: "http://localhost:3000/login/\(email)") else { return }
        URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            let httpResponse = urlResponse as? HTTPURLResponse
            if httpResponse?.statusCode == 200{
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    let empData = try! jsonDecoder.decode(UserInfo.self, from: data)
                    completion(empData)
                }
            }else{
                let user = UserInfo.init(nom: "", prenom: "", email: "", password: "", role: "", telephone: "")
                completion(user)
            }
            
        }.resume()
    }
    
    func createUser(user: UserInfo, completion: @escaping(Error?) -> () ){
        guard let url = URL(string: "http://localhost:3000/user/create") else { return }
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(user)
            print(user)
            print(try JSONEncoder().encode(user))
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                      let jsonData = data else{
                          print("failed")
                          completion(error)
                          return
                      }
                do {
                    let messageData = try JSONDecoder().decode(UserInfo.self, from: jsonData)
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
