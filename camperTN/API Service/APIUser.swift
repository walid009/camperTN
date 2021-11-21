//
//  APIUser.swift
//  camperTN
//
//  Created by chekir walid on 9/11/2021.
//

import Foundation

enum AuthenticationError: Error{
    case invalidCredentials
    case custom(errorMessage: String)
}

class APIUser: NSObject{
    
    func login(email: String, password: String, completion: @escaping (Result<String, AuthenticationError>) -> ()){
        guard let url = URL(string: "http://localhost:3000/users/login") else { return }
        
        let body = LoginRequestBody(email: email, password: password)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else{
                completion(.failure(.custom(errorMessage: "No data")))
                return
            }
            guard let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) else{
                completion(.failure(.invalidCredentials))
                return
            }
            guard let token = loginResponse.token else {
                completion(.failure(.invalidCredentials))
                return
            }
            completion(.success(token))
        }.resume()
    }
    
    func getUser(token: String, email: String,completion : @escaping (UserInfoLogin) -> ()){
        guard let url = URL(string: "http://localhost:3000/users/getUser/\(email)") else { return }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            let httpResponse = urlResponse as? HTTPURLResponse
            if httpResponse?.statusCode == 200{
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    let empData = try! jsonDecoder.decode(UserInfoLogin.self, from: data)
                    completion(empData)
                }
            }else{
                let user = UserInfoLogin.init(_id: "",nom: "", prenom: "", email: "", password: "", role: "", telephone: "")
                completion(user)
            }
            
        }.resume()
    }
    
    func getUserWithoutAuthenticate(email: String,completion : @escaping (UserInfoLogin) -> ()){
        guard let url = URL(string: "http://localhost:3000/users/getUserWithoutAuthenticate/\(email)") else { return }
        URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            let httpResponse = urlResponse as? HTTPURLResponse
            if httpResponse?.statusCode == 200{
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    let empData = try! jsonDecoder.decode(UserInfoLogin.self, from: data)
                    completion(empData)
                }
            }else{
                let user = UserInfoLogin.init(_id: "",nom: "", prenom: "", email: "", password: "", role: "", telephone: "")
                completion(user)
            }
        }.resume()
    }
    
    func createUser(user: UserInfo, completion: @escaping(Error?) -> () ){
        guard let url = URL(string: "http://localhost:3000/users/create") else { return }
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
    
    func updateUserProfile(token: String, id:String, user: UserProfiel, completion: @escaping(Error?) -> () ){
        guard let url = URL(string: "http://localhost:3000/users/update/\(id)") else { return }
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            urlRequest.httpMethod = "PUT"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(user)
            print(user)
            print(try JSONEncoder().encode(user))
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
    
    func CheckEmailExist(email: String,completion : @escaping (EmailExist) -> ()){
        guard let url = URL(string: "http://localhost:3000/users/emailexist/\(email)") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else{
                print("error !")
                return
            }
            guard let emailExist = try? JSONDecoder().decode(EmailExist.self, from: data) else{
                print("no data event")
                return
            }
            completion(emailExist)
        }.resume()
        /*URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if let data = data {
                
                let jsonDecoder = JSONDecoder()
                
                let empData = try! jsonDecoder.decode([EventData].self, from: data)
                    completion(empData)
            }
        }.resume()*/
    }
}
