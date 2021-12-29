//
//  SignUpViewController.swift
//  camperTN
//
//  Created by chekir walid on 2/11/2021.
//

import UIKit

class SignUpViewController: UIViewController {
    let role:[String] = ["Campeur","Organisateur"]
    var selectedRole:String?
    var userViewModel: UserViewModel?
    var exist:Bool?
    //
    @IBOutlet weak var prenomTxtF: UITextField!
    @IBOutlet weak var nomTxtF: UITextField!
    @IBOutlet weak var emailTxtF: UITextField!
    @IBOutlet weak var passwordTxtF: UITextField!
    @IBOutlet weak var passwordconfirmationTxtF: UITextField!
    @IBOutlet weak var rolePicker: UIPickerView!
    @IBOutlet weak var phoneTxtF: UITextField!
    @IBOutlet weak var signupBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signupBTN.layer.cornerRadius = 25
        signupBTN.layer.borderWidth = 1
        signupBTN.layer.borderColor = UIColor.black.cgColor
        
        rolePicker.dataSource = self
        rolePicker.delegate = self
        selectedRole = "campeur"
        print(selectedRole ?? "no selected picker")
        userViewModel = UserViewModel()
        // Do any additional setup after loading the view.
    }
    
    func callToViewModelForCheckEmail(email: String, user: UserInfo){
        userViewModel?.checkEmail(email: email )
        self.userViewModel?.bindUserViewModelToController = {
            DispatchQueue.main.async {
                self.exist = self.userViewModel?.emailExist.exist
                print(self.exist!)
                if self.exist != nil {
                    if self.exist! {
                        //1
                        let alert = UIAlertController(title: "ERROR", message: "Email Already Used", preferredStyle: .alert)
                        //2
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        //3
                        alert.addAction(action)
                        //4
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        self.userViewModel?.signUp(user: user)
                        self.navigationController?.popToRootViewController(animated: false)
                    }
                }
            }
        }
    }
    
    @IBAction func btnSingupPressed(_ sender: Any) {
        let prenom = prenomTxtF.text
        let nom = nomTxtF.text
        let email = emailTxtF.text
        let password = passwordTxtF.text
        let passwordConfirmation = passwordconfirmationTxtF.text
        let phone = phoneTxtF.text
        if prenom == "" || nom == "" || email == "" || password == "" || phone == ""{
            //1
            let alert = UIAlertController(title: "ERROR", message: "Complete All Field plz", preferredStyle: .alert)
            //2
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            //3
            alert.addAction(action)
            //4
            self.present(alert, animated: true, completion: nil)
        }else{
            if password == passwordConfirmation {
                if phone!.count == 8 {
                    let user = UserInfo.init(nom: nom!, prenom: prenom!, email: email!, password: password!, role: selectedRole!, telephone: phone!, approved: false)
                   self.callToViewModelForCheckEmail(email: email!,user: user)
                    
                }else{
                    //1
                    let alert = UIAlertController(title: "ERROR", message: "You must have a valid phone number with 8 number", preferredStyle: .alert)
                    //2
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    //3
                    alert.addAction(action)
                    //4
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                //1
                let alert = UIAlertController(title: "ERROR", message: "You're Password does not match with Password Confirmation", preferredStyle: .alert)
                //2
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                //3
                alert.addAction(action)
                //4
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}

extension SignUpViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // with delegate we display content
        return role[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRole = role[row]
        print(selectedRole!)
    }
}

