//
//  User.swift
//  camperTN
//
//  Created by chekir walid on 9/11/2021.
//

import Foundation

struct UserInfo: Codable {
    let nom: String
    let prenom: String
    let email: String
    let password : String
    let role: String
    let telephone: String
}
