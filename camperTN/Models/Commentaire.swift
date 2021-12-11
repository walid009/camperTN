//
//  Commentaire.swift
//  camperTN
//
//  Created by chekir walid on 10/12/2021.
//

import Foundation

struct Commentaire:Codable{
    let idEvent: String?
    let sender: String?
    let body: String?
    let date: Double?
}
struct CommentaireData:Codable{
    let _id: String?
    let idEvent: String?
    let sender: String?
    let body: String?
    let date: Double?
}
