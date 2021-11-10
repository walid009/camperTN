//
//  EventData.swift
//  camperTN
//
//  Created by chekir walid on 4/11/2021.
//

import Foundation

struct EventData: Codable {
    let _id: String?
    let titre: String
    let description: String
    let position : Position?
    let createur: User?
    let participants: [Participant]?
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
    let createur: User?
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
    let telephone: Int
    let role: String
}
