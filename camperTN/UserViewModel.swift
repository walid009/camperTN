//
//  UserViewModel.swift
//  camperTN
//
//  Created by chekir walid on 9/11/2021.
//

import Foundation

class UserViewModel: NSObject{
    //var
    private var apiUser: APIUser?
    //private var apiRequest=APIRequest.init(url: "http://localhost:3000/events/create")
    private(set) var userData : UserInfo! {
        didSet {
            self.bindUserViewModelToController()
        }
    }
    
    var  bindUserViewModelToController : (() -> ()) = {
    }
    
    override init() {
        super.init()
        self.apiUser = APIUser()
        //getAllEvents()
    }
    
    func login(email: String){
        self.apiUser?.getUser(email: email, completion: { userData in
            self.userData = userData
        })
    }
    
    func signUp(user: UserInfo){
        self.apiUser?.createUser(user: user, completion: { err in
            print(err ?? "succes")
        })
    }
    
    /*func getAllEvents() {
        self.apiEvent!.getEvents { eventData in
            self.eventData = eventData
        }
    }*/
    
}
