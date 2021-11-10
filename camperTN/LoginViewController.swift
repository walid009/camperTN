//
//  ViewController.swift
//  camperTN
//
//  Created by chekir walid on 30/10/2021.
//

import UIKit

class LoginViewController: UIViewController {
    //var
    var userViewModel: UserViewModel?
    var userData: UserInfo?
    var valid: Bool = false
    //
    @IBOutlet weak var emailTxtF: UITextField!
    @IBOutlet weak var passwordTxtF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        
        userData = UserInfo.init(nom: "", prenom: "", email: "", password: "", role: "", telephone: "")
        userViewModel = UserViewModel()
        // Do any additional setup after loading the view.
    }
    //IBAction
    @IBAction func SignInBtnPressed(_ sender: UIButton) {
        let email = emailTxtF.text
        let password = passwordTxtF.text
        if email == "" || password == ""{
            //1
            let alert = UIAlertController(title: "ERROR", message: "Complete All Field plz", preferredStyle: .alert)
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
                        self.valid = true
                    }else{
                        self.valid = false
                    }
                }
            }
            if valid == true {
                if userData?.role == "Organisateur" {
                    self.performSegue(withIdentifier: "ShowViewOrganisateurEvents", sender: nil)
                }
                if userData?.role == "campeur"{
                    self.performSegue(withIdentifier: "ShowViewCampeurEvents", sender: nil)
                }
            }/*else{
                //1
                let alert = UIAlertController(title: "Invalid Data", message: "be careful", preferredStyle: .alert)
                //2
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                //3
                alert.addAction(action)
                //4
                self.present(alert, animated: true, completion: nil)
            }*/
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowViewOrganisateurEvents"{
            /*if let vc = segue.destination as? OrganisateurEventsViewController{
                print("")
            }*/
        }
    }
}

