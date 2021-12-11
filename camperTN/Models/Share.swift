//
//  Share.swift
//  camperTN
//
//  Created by chekir walid on 9/12/2021.
//

import Foundation

struct likeData: Codable{
    let count:Int?
    let isliked:Bool?
}

struct ShareDataUpdate: Codable {
    let _id: String
    let emailcampeur: String
}

struct shareEventData: Codable{
    let _id:String?
    let titre:String?
    let description: String?
    //let date: Date?
    let Longitude: Double?
    let Latitude: Double?
    let emailcreateur: String?
    let emailpartageur: String?
}

struct shareEvent: Codable{
    let titre:String?
    let description: String?
    //let date: Date?
    let Longitude: Double?
    let Latitude: Double?
    let emailcreateur: String?
    let emailpartageur: String?
}

struct like: Codable{
    let emailcampeur:String?
    let like:Bool?
}
