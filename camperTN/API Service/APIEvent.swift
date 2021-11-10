//
//  EventManager.swift
//  camperTN
//
//  Created by chekir walid on 4/11/2021.
//

import Foundation

class APIEvent: NSObject{
    private let sourcesURL = URL(string: "http://localhost:3000/events")!
    
    func getEvents(completion : @escaping ([EventData]) -> ()){
        URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
            if let data = data {
                
                let jsonDecoder = JSONDecoder()
                
                let empData = try! jsonDecoder.decode([EventData].self, from: data)
                    completion(empData)
            }
        }.resume()
    }
    
    func createEvent(event: Event, completion: @escaping(Error?) -> () ){
        guard let url = URL(string: "http://localhost:3000/event/create") else { return }
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
        guard let url = URL(string: "http://localhost:3000/event/update/\(event._id)") else { return }
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
        guard let url = URL(string: "http://localhost:3000/event/delete/\(event._id)") else { return }
        
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "DELETE"
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let err = error {
                    print(err)
                }
            }.resume()
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
