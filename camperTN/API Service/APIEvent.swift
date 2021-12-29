//
//  EventManager.swift
//  camperTN
//
//  Created by chekir walid on 4/11/2021.
//

import Foundation
import UIKit

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
    
    func getEventsCreatedBy(email: String,token: String,completion : @escaping ([EventData]) -> ()){
        guard let url = URL(string: "\(baseURL)/events/\(email)") else {
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
    }
    
    func createEventImage(image: UIImage, event:Event, completion: @escaping(Error?) -> () ){
        guard let url = URL(string: "http://localhost:3000/events/create") else { return }
        var urlRequest = URLRequest(url: url)
        
        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        // Set the URLRequest to POST and to the specified URL
        urlRequest.httpMethod = "POST"

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        // Add the reqtype field and its value to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"titre\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(event.titre)".data(using: .utf8)!)

        // Add the userhash field and its value to the raw http reqyest data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"description\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(event.description)".data(using: .utf8)!)
        
        // Add the reqtype field and its value to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"Longitude\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(event.position!.Longitude)".data(using: .utf8)!)

        // Add the userhash field and its value to the raw http reqyest data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"Latitude\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(event.position!.Latitude)".data(using: .utf8)!)
        
        // Add the userhash field and its value to the raw http reqyest data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"emailcreateur\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(event.emailcreateur)".data(using: .utf8)!)
        
        // Add the userhash field and its value to the raw http reqyest data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"phonecreateur\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(event.phonecreateur!)".data(using: .utf8)!)

        // Add the userhash field and its value to the raw http reqyest data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"date\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(event.date!)".data(using: .utf8)!)
        
        // Add the userhash field and its value to the raw http reqyest data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"price\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(event.price!)".data(using: .utf8)!)
        
        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.png\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)

        // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        // According to the HTTP 1.1 specification https://tools.ietf.org/html/rfc7230
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            
            if(error != nil){
                print("\(error!.localizedDescription)")
            }
            
            guard let responseData = responseData else {
                print("no response data")
                return
            }
            
            if let responseString = String(data: responseData, encoding: .utf8) {
                print(data)
                print("uploaded to: \(responseString)")
            }
        }).resume()
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
    
    func UsersParticipateTothisEvent(id: String, completion : @escaping (checkUsersInEventForDelete) -> ()){
        guard let url = URL(string: "\(baseURL)/events/UsersParticipateTothisEvent/\(id)") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else{
                print("error !")
                return
            }
            guard let emailExist = try? JSONDecoder().decode(checkUsersInEventForDelete.self, from: data) else{
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
/*
 
 func createEvent(event: Event, completion: @escaping(Error?) -> () ){
     guard let url = URL(string: "http://localhost:3000/events/createWithoutImage") else { return }
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
 
 
 struct APIRequest {
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
