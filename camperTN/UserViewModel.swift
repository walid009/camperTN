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
    
    private(set) var keyIsOrNotCorrect : KeyCorrect! {
        didSet {
            self.bindUserViewModelToController()
        }
    }
    
    private(set) var orgUsersData : [UserInfoLogin]! {
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
    
    func getAllOrganisateurUsers(token: String) {
        self.apiUser?.getAllOrganisateurUser(token: token, completion: { orgUsersData in
            self.orgUsersData = orgUsersData
        })
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
        defaults.setValue(email, forKey: "email")
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
    
    
    func ApproveOrganisateur(token: String, id: String){
        self.apiUser?.ApprovedUser(token: token, id: id, completion: { err in
            print(err ?? "")
        })
    }
    func DisapproveOrganisateur(token: String, id: String){
        self.apiUser?.DisapprovedUser(token: token, id: id, completion: { err in
            print(err ?? "")
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
    
    func checkKeyCorrectOrNot(email: String,key: String) {
        apiUser?.CheckIfKeyResetCorrect(email: email, key: key, completion: { KeyCorrect in
            self.keyIsOrNotCorrect = KeyCorrect
        })
    }
    
    func sendMailResetPassword(email: String){
        self.apiUser?.updateSendMailForgetPassword(email: email, completion: { error in
            print(error ?? "error sendMailResetPassword")
        })
    }
    
    func sendMailModifiedPasswordSuccess(email: String,password: String){
        self.apiUser?.updateSendModifiedPassword(email: email, password: password, completion: { error in
            print(error ?? "")
        })
    }
    
    func loginGmail(email: String){
        let defaults = UserDefaults.standard // stockage zrila mch kima core data
        defaults.setValue(email, forKey: "email")
        apiUser?.loginGmail(email: email) { result in
            switch result{
            case .success(let token):
                defaults.setValue(token, forKey: "jsonwebtoken")
                defaults.synchronize()
                print("token for my gmail: \(token)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /*func getAllEvents() {
        self.apiEvent!.getEvents { eventData in
            self.eventData = eventData
        }
    }*/
    
}
