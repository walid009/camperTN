//
//  ResetPasswordViewController.swift
//  camperTN
//
//  Created by chekir walid on 28/11/2021.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailLB: UILabel!
    @IBOutlet weak var pwdLB: UILabel!
    @IBOutlet weak var pwdConfirmLB: UILabel!
    @IBOutlet weak var keyLB: UILabel!
    @IBOutlet weak var emailTXTF: UITextField!
    @IBOutlet weak var pwdTXTF: UITextField!
    @IBOutlet weak var pwdConfirmTXTF: UITextField!
    @IBOutlet weak var keyTXTF: UITextField!
    @IBOutlet weak var sendBTN: UIButton!
    @IBOutlet weak var resetBTN: UIButton!
    @IBOutlet weak var cancelBTN: UIButton!
    //var
    var userViewModel: UserViewModel?
    var key:Bool?
    var exist:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTXTF.text = ""
        pwdTXTF.text = ""
        pwdConfirmTXTF.text = ""
        keyTXTF.text = ""
        
        userViewModel = UserViewModel()
        // Do any additional setup after loading the view.
    }
    
    func callToViewModelForCheckEmail(email: String){
        userViewModel?.checkEmail(email: email )
        self.userViewModel?.bindUserViewModelToController = {
            DispatchQueue.main.async {
                self.exist = self.userViewModel?.emailExist.exist
                print(self.exist!)
                if self.exist != nil {
                    if self.exist! {
                        self.userViewModel?.sendMailResetPassword(email: email)
                        self.emailLB.isHidden = true
                        self.emailTXTF.isHidden = true
                        self.sendBTN.isHidden = true
                        
                        self.pwdLB.isHidden = false
                        self.pwdTXTF.isHidden = false
                        self.pwdConfirmLB.isHidden = false
                        self.pwdConfirmTXTF.isHidden = false
                        self.keyLB.isHidden = false
                        self.keyTXTF.isHidden = false
                        self.resetBTN.isHidden = false
                        self.cancelBTN.isHidden = false
                    }else{
                        //1
                        let alert = UIAlertController(title: "ERROR", message: "Email invalid !", preferredStyle: .alert)
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
    }
    
    @IBAction func sendEmailBtn(_ sender: Any) {
        if emailTXTF.text == ""{
            //1
            let alert = UIAlertController(title: "ERROR", message: "Complete email field!", preferredStyle: .alert)
            //2
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            //3
            alert.addAction(action)
            //4
            self.present(alert, animated: true, completion: nil)

        }else{
            callToViewModelForCheckEmail(email: emailTXTF.text!)
        }
    }
    
    func callToViewModelForCheckIfKeyCorrectOrNot(email: String,key: String){
        userViewModel?.checkKeyCorrectOrNot(email: email, key: key)
        self.userViewModel?.bindUserViewModelToController = {
            DispatchQueue.main.async {
                self.key = self.userViewModel?.keyIsOrNotCorrect.key
                print(self.key!)
                if self.key != nil {
                    if self.key! {
                        self.userViewModel?.sendMailModifiedPasswordSuccess(email: email, password: self.pwdTXTF.text!)
                        self.emailTXTF.text = ""
                        self.pwdTXTF.text = ""
                        self.pwdConfirmTXTF.text = ""
                        self.keyTXTF.text = ""
                        self.navigationController?.popToRootViewController(animated: false)
                    }else{
                        //1
                        let alert = UIAlertController(title: "ERROR", message: "Key Not Correct !", preferredStyle: .alert)
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
    }
    
    @IBAction func resetPwdBtn(_ sender: Any) {
        if pwdTXTF.text == "" || pwdConfirmTXTF.text == "" || keyTXTF.text == "" {
            //1
            let alert = UIAlertController(title: "ERROR", message: "complete all field !", preferredStyle: .alert)
            //2
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            //3
            alert.addAction(action)
            //4
            self.present(alert, animated: true, completion: nil)
        }else{
            if pwdTXTF.text == pwdConfirmTXTF.text {
                print("check key correct or no")
                callToViewModelForCheckIfKeyCorrectOrNot(email: emailTXTF.text!, key: keyTXTF.text!)
            }else{
                //1
                let alert = UIAlertController(title: "ERROR", message: "you're password not match with confirm password!", preferredStyle: .alert)
                //2
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                //3
                alert.addAction(action)
                //4
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func cancelBtn(_ sender: Any) {
        //self.emailTXTF.text = ""
        pwdTXTF.text = ""
        pwdConfirmTXTF.text = ""
        keyTXTF.text = ""
        
        emailLB.isHidden = false
        emailTXTF.isHidden = false
        sendBTN.isHidden = false
        
        pwdLB.isHidden = true
        pwdTXTF.isHidden = true
        pwdConfirmLB.isHidden = true
        pwdConfirmTXTF.isHidden = true
        keyLB.isHidden = true
        keyTXTF.isHidden = true
        resetBTN.isHidden = true
        cancelBTN.isHidden = true
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
