//
//  EventData.swift
//  camperTN
//
//  Created by chekir walid on 4/11/2021.
//

import Foundation
import UIKit

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "imagefile.jpg"
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}

struct EventData: Codable {
    let _id: String?
    let titre: String
    let description: String
    let position : Position?
    let idcreateur: String?
    let participants: [UserDataWithNotPassword]?
    //let createdAt: Date
    //let updatedAt: Date
}
struct EventDataUpdate: Codable {
    let _id: String
    let titre: String
    let description: String
    
}

struct Event: Codable {
    let titre: String
    let description: String
    let position : Position?
    let idcreateur: String?
    let participants: [Participant]?
}

struct EventID: Codable {
    let _id: String
}

struct Position: Codable{
    let Longitude: Double
    let Latitude: Double
}

struct Participant: Codable {
    let campeur: User
}

struct User: Codable {
    let _id: String
    let nom: String
    let prenom: String
    let email: String
    let password: String
    let telephone: String
    let role: String
}
