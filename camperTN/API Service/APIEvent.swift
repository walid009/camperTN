//
//  EventManager.swift
//  camperTN
//
//  Created by chekir walid on 4/11/2021.
//

import Foundation

class APIEvent: NSObject{
    func getEvents(token: String,completion : @escaping ([EventData]) -> ()){
        guard let url = URL(string: "http://localhost:3000/events") else {
            return
        }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else{
                print("error !")
                return
            }
            guard let eventData = try? JSONDecoder().decode([EventData].self, from: data) else{
                print("no data event")
                return
            }
            completion(eventData)
        }.resume()
        /*URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if let data = data {
                
                let jsonDecoder = JSONDecoder()
                
                let empData = try! jsonDecoder.decode([EventData].self, from: data)
                    completion(empData)
            }
        }.resume()*/
    }
    
    func createEvent(event: Event, completion: @escaping(Error?) -> () ){
        guard let url = URL(string: "http://localhost:3000/events/create") else { return }
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(event)
            print(event)
            print(try JSONEncoder().encode(event))
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                      let jsonData = data else{
                          print("failed")
                          completion(error)
                          return
                      }
                do {
                    let messageData = try JSONDecoder().decode(EventData.self, from: jsonData)
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
    
    func updateEvent(event: EventDataUpdate, completion: @escaping(Error?) -> () ){
        guard let url = URL(string: "http://localhost:3000/events/update/\(event._id)") else { return }
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "PUT"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(event)
            print(event)
            print(try JSONEncoder().encode(event))
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

    
    func deleteEvent(event: EventID, completion: @escaping(Error?) -> () ){
        guard let url = URL(string: "http://localhost:3000/events/delete/\(event._id)") else { return }
        
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "DELETE"
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let err = error {
                    print(err)
                }
            }.resume()
    }
    
    func CheckUserAlreadyParticipate(id: String,email: String,completion : @escaping (EmailExist) -> ()){
        guard let url = URL(string: "http://localhost:3000/events/UserAlreadyParticipate/\(id)/\(email)") else {
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
    }
    
    func updateEventWithUserParticipate(idEvent:String,user: UserDataWithNotPassword, completion: @escaping(Error?) -> () ){
        guard let url = URL(string: "http://localhost:3000/events/participate/\(idEvent)") else { return }
        do {
            var urlRequest = URLRequest(url: url)
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
    
}

/*struct APIRequest {
    let url: String
    func createEvent(event: Event, completion: @escaping(Error?) -> () ){
        guard let url = URL(string: url) else { return }
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(event)
            print(event)
            print(try JSONEncoder().encode(event))
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                      let jsonData = data else{
                          print("failed")
                          completion(error)
                          return
                      }
                do {
                    let messageData = try JSONDecoder().decode(EventData.self, from: jsonData)
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
*/
