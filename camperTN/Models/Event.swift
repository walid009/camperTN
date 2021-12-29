//
//  EventData.swift
//  camperTN
//
//  Created by chekir walid on 4/11/2021.
//

import Foundation
import UIKit

struct ImageRequest : Encodable
{
    let image : String
}

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

struct checkUsersInEventForDelete: Codable{
    let usersExist: Bool
}

struct EventData: Codable {
    let _id: String?
    let titre: String
    let description: String
    let Longitude: Double?
    let Latitude: Double?
    let emailcreateur: String
    let participants: [UserDataWithNotPassword]?
    let image: String?
    let phonecreateur: String?
    let price: String?
    let date: String?
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
    let emailcreateur: String
    let participants: [Participant]?
    let phonecreateur: String?
    let date: Date?
    let price: String?
}

struct EventID: Codable {
    let _id: String
}

struct Position: Codable{
    let Longitude: Double
    let Latitude: Double
}

struct Participant: Codable {
    let campeur: UserDataWithNotPassword
}


