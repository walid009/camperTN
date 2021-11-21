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
    
    private(set) var userDataLogin : UserInfoLogin! {
        didSet {
            self.bindUserViewModelToController()
        }
    }
    
    private(set) var emailExist : EmailExist! {
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
    
    func FindUserByEmail(token: String, email: String){
        apiUser?.getUser(token: token, email: email, completion: { userInfoLogin in
            self.userDataLogin = userInfoLogin
        })
    }
    
    func FindUserByEmailWithoutAuthenticate(email: String){
        apiUser?.getUserWithoutAuthenticate(email: email, completion: { userInfoLogin in
            self.userDataLogin = userInfoLogin
        })
    }
    
    func login(email: String,password: String){
        let defaults = UserDefaults.standard
        apiUser?.login(email: email, password: password) { result in
            switch result{
            case .success(let token):
                defaults.setValue(token, forKey: "jsonwebtoken")
                print(token)
                self.apiUser?.getUser(token: token,email: email, completion: { userData in
                    self.userDataLogin = userData
                })
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    /*func login(email: String){
        self.apiUser?.getUser(email: email, completion: { userData in
            self.userData = userData
        })
    }*/
    
    func signUp(user: UserInfo){
        self.apiUser?.createUser(user: user, completion: { err in
            print(err ?? "ici")
        })
    }
    
    func updateProfile(token: String, id: String, user: UserProfiel){
        self.apiUser?.updateUserProfile(token: token, id: id, user: user, completion: { err in
            print(err ?? "success")
        })
    }
    
    func checkEmail(email: String) {
        apiUser?.CheckEmailExist(email: email, completion: { EmailExist in
            self.emailExist = EmailExist
        })
    }
    /*func getAllEvents() {
        self.apiEvent!.getEvents { eventData in
            self.eventData = eventData
        }
    }*/
    
}
