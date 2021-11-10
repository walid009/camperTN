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
    //
    @IBOutlet weak var prenomTxtF: UITextField!
    @IBOutlet weak var nomTxtF: UITextField!
    @IBOutlet weak var emailTxtF: UITextField!
    @IBOutlet weak var passwordTxtF: UITextField!
    @IBOutlet weak var rolePicker: UIPickerView!
    @IBOutlet weak var phoneTxtF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rolePicker.dataSource = self
        rolePicker.delegate = self
        selectedRole = "campeur"
        print(selectedRole ?? "no selected picker")
        userViewModel = UserViewModel()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnSingupPressed(_ sender: Any) {
        let prenom = prenomTxtF.text
        let nom = prenomTxtF.text
        let email = emailTxtF.text
        let password = passwordTxtF.text
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
            let user = UserInfo.init(nom: nom!, prenom: prenom!, email: email!, password: password!, role: selectedRole!, telephone: phone!)
            userViewModel?.signUp(user: user)
            self.navigationController?.popToRootViewController(animated: false)
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

