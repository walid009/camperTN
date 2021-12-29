//
//  SignUpMethodViewController.swift
//  camperTN
//
//  Created by chekir walid on 2/11/2021.
//

import UIKit
import GoogleSignIn
class SignUpMethodViewController: UIViewController {
    //let
    let role:[String] = ["Campeur","Organisateur"]
    //var
    var userViewModel: UserViewModel?
    var selectedRole:String?
    var prenom:String?
    var nom:String?
    var email:String?
    //IBOutlet
    @IBOutlet weak var passwordTxtF: UITextField!
    @IBOutlet weak var passwordConfirmationTxtF: UITextField!
    @IBOutlet weak var rolePicker: UIPickerView!
    @IBOutlet weak var phoneTxtF: UITextField!
    @IBOutlet weak var continueBTN: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        continueBTN.layer.cornerRadius = 25
        continueBTN.layer.borderWidth = 1
        continueBTN.layer.borderColor = UIColor.black.cgColor
        
        rolePicker.dataSource = self
        rolePicker.delegate = self
        selectedRole = "campeur"
        print(selectedRole ?? "no selected picker")
        userViewModel = UserViewModel()
        print(email!)
        print(nom!)
        print(prenom!)
    }
    
    //IBAction
    @IBAction func btnContinuePressed(_ sender: Any) {
        let password = passwordTxtF.text
        let passwordConfirmation = passwordConfirmationTxtF.text
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
                    userViewModel?.signUp(user: user)
                    self.navigationController?.popToRootViewController(animated: false)
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SignUpMethodViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
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
