//
//  ViewController.swift
//  camperTN
//
//  Created by chekir walid on 30/10/2021.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    let signInConfig = GIDConfiguration.init(clientID: "60316353411-f1onecmje817un4mn258qij78b0d6hh9.apps.googleusercontent.com")
    //var
    var userViewModel: UserViewModel?
    var userData: UserInfoLogin?
    var exist:Bool?
    //
    @IBOutlet weak var emailTxtF: UITextField!
    @IBOutlet weak var passwordTxtF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        
        userData = UserInfoLogin.init(_id: "",nom: "", prenom: "", email: "", password: "", role: "", telephone: "")
        userViewModel = UserViewModel()
        // Do any additional setup after loading the view.
    }
    //IBAction
    @IBAction func SignInBtnPressed(_ sender: UIButton) {
        let email = emailTxtF.text
        let password = passwordTxtF.text
        if email == "" || password == ""{
            //1
            let alert = UIAlertController(title: "ERROR", message: "Complete All Field", preferredStyle: .alert)
            //2
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            //3
            alert.addAction(action)
            //4
            self.present(alert, animated: true, completion: nil)
        }else{
            userViewModel?.login(email: email!, password: password!)
            userViewModel?.bindUserViewModelToController = {
                DispatchQueue.main.async {
                    self.userData = self.userViewModel?.userDataLogin
                    print(self.userData ?? "empty")
                    if self.userData?.email == email {
                        currentUser._id = self.userData?._id
                        currentUser.email = self.userData?.email
                        currentUser.password = self.userData?.password
                        currentUser.role = self.userData?.role
                        if self.userData?.role == "Organisateur" {
                            self.performSegue(withIdentifier: "ShowViewOrganisateurEvents", sender: nil)
                        }
                        if self.userData?.role == "campeur"{
                            self.performSegue(withIdentifier: "ShowViewCampeurEvents", sender: nil)
                        }
                    }
                }
            }
            emailTxtF.text = ""
            passwordTxtF.text = ""
            /*
            //1
            let alert = UIAlertController(title: "ERROR", message: "Incorrect Data", preferredStyle: .alert)
            //2
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            //3
            alert.addAction(action)
            //4
            self.present(alert, animated: false, completion: nil)*/
        }
        /*let email = emailTxtF.text
        let password = passwordTxtF.text
        if email == "" || password == ""{
            //1
            let alert = UIAlertController(title: "ERROR", message: "Complete All Field", preferredStyle: .alert)
            //2
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            //3
            alert.addAction(action)
            //4
            self.present(alert, animated: true, completion: nil)
        }else{
            userViewModel?.login(email: email!)
            userViewModel?.bindUserViewModelToController = {
                DispatchQueue.main.async {
                    self.userData = self.userViewModel?.userData
                    
                    print(self.userData ?? "empty")
                    if self.userData?.email == email && self.userData?.password == password{
                        if self.userData?.role == "Organisateur" {
                            self.performSegue(withIdentifier: "ShowViewOrganisateurEvents", sender: nil)
                        }
                        if self.userData?.role == "campeur"{
                            self.performSegue(withIdentifier: "ShowViewCampeurEvents", sender: nil)
                        }
                    }else{
                        //1
                        let alert = UIAlertController(title: "ERROR", message: "Incorrect Data", preferredStyle: .alert)
                        //2
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        //3
                        alert.addAction(action)
                        //4
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            emailTxtF.text = ""
            passwordTxtF.text = ""
        }*/
    }
    
    
    @IBAction func SignWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }

            // If sign in succeeded, display the app's main content View.
            self.callToViewModelForCheckEmail(profile: (user?.profile)!)
            
            //print(user?.profile?.email ?? "no email")
            
            //self.performSegue(withIdentifier: "showCompleteInformation", sender: user?.profile)
          }
    }
    
    func callToViewModelForCheckEmail(profile: GIDProfileData){
        userViewModel?.checkEmail(email: profile.email )
        self.userViewModel?.bindUserViewModelToController = {
            DispatchQueue.main.async {
                self.exist = self.userViewModel?.emailExist.exist
                print(self.exist!)
                if self.exist != nil {
                    if self.exist! {
                        self.userViewModel?.FindUserByEmailWithoutAuthenticate(email: profile.email)
                        self.userViewModel?.bindUserViewModelToController = {
                            DispatchQueue.main.async {
                                self.userData = self.userViewModel?.userDataLogin
                                
                                print(self.userData ?? "empty")
                                if self.userData != nil{
                                    currentUser._id = self.userData?._id
                                    currentUser.email = self.userData?.email
                                    currentUser.password = ""
                                    currentUser.role = self.userData?.role
                                    if self.userData?.role == "Organisateur" {
                                        self.performSegue(withIdentifier: "ShowViewOrganisateurEvents", sender: nil)
                                    }
                                    if self.userData?.role == "campeur"{
                                        self.performSegue(withIdentifier: "ShowViewCampeurEvents", sender: nil)
                                    }
                                }
                            }
                        }
                    }else{
                        self.performSegue(withIdentifier: "showCompleteInformation", sender: profile)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCompleteInformation"{
            let profile = sender as! GIDProfileData
            if let vc = segue.destination as? SignUpMethodViewController{
                vc.email = profile.email
                vc.nom = profile.familyName
                vc.prenom = profile.givenName
            }
        }
    }
}

