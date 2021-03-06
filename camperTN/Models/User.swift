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
    static var nom: String?
    static var prenom: String?
    static var telephone: String?
    static var approved:Bool?
}

struct EmailExist: Codable{
    let exist: Bool
}

struct KeyCorrect: Codable{
    let key: Bool
}

struct UserDataWithNotPassword: Codable {
    let _id: String
    let nom: String
    let prenom: String
    let email: String
    let role: String
    let telephone: String
    let approved:Bool
}
struct LoginRequestBodyGmail: Codable{
    let email:String?
}

struct UserInfoLogin: Codable {
    let _id: String
    let nom: String
    let prenom: String
    let email: String
    let password : String
    let role: String
    let telephone: String
    let approved:Bool
}
struct UserProfiel: Codable {
    let nom: String
    let prenom: String
    let telephone: String
    let approved:Bool
}

struct UserInfo: Codable {
    let nom: String
    let prenom: String
    let email: String
    let password : String
    let role: String
    let telephone: String
    let approved:Bool
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
