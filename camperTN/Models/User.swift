//
//  User.swift
//  camperTN
//
//  Created by chekir walid on 9/11/2021.
//

import Foundation

class currentUser{
    static var _id: String?
    static var email: String?
    static var password : String?
    static var role: String?
}

struct EmailExist: Codable{
    let exist: Bool
}

struct UserInfoLogin: Codable {
    let _id: String
    let nom: String
    let prenom: String
    let email: String
    let password : String
    let role: String
    let telephone: String
}
struct UserProfiel: Codable {
    let nom: String
    let prenom: String
    let telephone: String
}

struct UserInfo: Codable {
    let nom: String
    let prenom: String
    let email: String
    let password : String
    let role: String
    let telephone: String
}

struct LoginRequestBody: Codable{
    let email:String?
    let password:String
}

struct LoginResponse: Codable{
    let token: String?
    let message: String?
    let success: Bool?
}
