//
//  ProfileViewController.swift
//  camperTN
//
//  Created by chekir walid on 8/11/2021.
//

import UIKit

class ProfileViewController: UIViewController {
    //let
    let defaults = UserDefaults.standard
    let userViewModel = UserViewModel()
    var userData: UserInfoLogin?
    
    @IBOutlet weak var roleLb: UILabel!
    @IBOutlet weak var prenomTxtF: UITextField!
    @IBOutlet weak var nomTxtF: UITextField!
    @IBOutlet weak var phoneTxtF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        roleLb.text = currentUser.role!
        print("start")
        callToViewModelForUIUpdate()
    }
    
    func callToViewModelForUIUpdate(){
        guard let token = defaults.string(forKey: "jsonwebtoken") else{
            return
        }
        userViewModel.FindUserByEmail(token: token, email: currentUser.email!)
        self.userViewModel.bindUserViewModelToController = {
            self.updateDataSource()
        }
    }
    
    func updateDataSource(){
        //print(data)
        DispatchQueue.main.async {
            self.userData = self.userViewModel.userDataLogin
            print(self.userData!)
            self.prenomTxtF.text = self.userData!.prenom
            self.nomTxtF.text = self.userData!.nom
            self.phoneTxtF.text = self.userData!.telephone
        }
    }
    
    @IBAction func btnUpdatePressed(_ sender: Any) {
        if roleLb.text == "" || prenomTxtF.text == "" || nomTxtF.text == "" || phoneTxtF.text == "" {
            //1
            let alert = UIAlertController(title: "ERROR", message: "Impossible to update profile with empty field !", preferredStyle: .alert)
            //2
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            //3
            alert.addAction(action)
            //4
            self.present(alert, animated: true, completion: nil)
        }else{
            if phoneTxtF.text!.count == 8 {
                guard let token = defaults.string(forKey: "jsonwebtoken") else{
                    return
                }
                let userProfile = UserProfiel.init(nom: nomTxtF.text!, prenom: prenomTxtF.text!, telephone: phoneTxtF.text!)
                userViewModel.updateProfile(token: token, id: currentUser._id!, user: userProfile)
                //1
                let alert = UIAlertController(title: "Message", message: "Updated Successfully !", preferredStyle: .alert)
                //2
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                //3
                alert.addAction(action)
                //4
                self.present(alert, animated: true, completion: nil)
            }else{
                //1
                let alert = UIAlertController(title: "ERROR", message: "You must have a valid phone number with 8 number !", preferredStyle: .alert)
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
