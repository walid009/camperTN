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
    @IBOutlet weak var infoUIVIew: UIView!
    @IBOutlet weak var updateBTN: UIButton!
    @IBOutlet weak var switchUI: UISwitch!
    @IBOutlet weak var switchUIDarkLight: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoUIVIew.layer.cornerRadius = 17
        infoUIVIew.layer.borderWidth = 0.1
        infoUIVIew.layer.shadowColor = UIColor.lightGray.cgColor
        infoUIVIew.layer.shadowOpacity = 1
        infoUIVIew.layer.shadowOffset = .zero
        infoUIVIew.layer.shadowRadius = 10
        infoUIVIew.layer.shouldRasterize = true
        infoUIVIew.layer.rasterizationScale = UIScreen.main.scale
        
        updateBTN.layer.cornerRadius = 25
        updateBTN.layer.borderWidth = 1
        updateBTN.layer.borderColor = UIColor.black.cgColor
        
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
    
    @IBAction func editSwitcherPressed(_ sender: Any) {
        if switchUI.isOn {
            nomTxtF.borderStyle = .roundedRect
            nomTxtF.backgroundColor = UIColor.systemGray6
            nomTxtF.isEnabled = true
            
            prenomTxtF.borderStyle = .roundedRect
            prenomTxtF.backgroundColor = UIColor.systemGray6
            prenomTxtF.isEnabled = true
            
            phoneTxtF.borderStyle = .roundedRect
            phoneTxtF.backgroundColor = UIColor.systemGray6
            phoneTxtF.isEnabled = true
            
            updateBTN.isHidden = false
        }else{
            nomTxtF.borderStyle = .none
            nomTxtF.backgroundColor = UIColor.lightText
            nomTxtF.isEnabled = false
            
            prenomTxtF.borderStyle = .none
            prenomTxtF.backgroundColor = UIColor.lightText
            prenomTxtF.isEnabled = false
            
            phoneTxtF.borderStyle = .none
            phoneTxtF.backgroundColor = UIColor.lightText
            phoneTxtF.isEnabled = false
            
            updateBTN.isHidden = true
        }
    }
    @IBAction func siwtchDarkLighPressed(_ sender: Any) {
        if switchUIDarkLight.isOn {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
        }else{
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        }
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
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
