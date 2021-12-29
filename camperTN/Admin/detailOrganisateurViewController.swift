//
//  detailOrganisateurViewController.swift
//  camperTN
//
//  Created by chekir walid on 29/12/2021.
//

import UIKit

class detailOrganisateurViewController: UIViewController {

    var email:String?
    var fname:String?
    var lname:String?
    var phone:String?
    var id:String?
    var approve:Bool?
    let userViewModel = UserViewModel()
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var infoUIVIew: UIView!
    @IBOutlet weak var imgOrg: UIImageView!
    @IBOutlet weak var approvedLb: UILabel!
    @IBOutlet weak var emailTxtf: UITextField!
    @IBOutlet weak var fNameTxtF: UITextField!
    @IBOutlet weak var lNameTxtF: UITextField!
    @IBOutlet weak var phoneTxtF: UITextField!
    @IBOutlet weak var btnApprove: UIButton!
    @IBOutlet weak var btnDisaprove: UIButton!
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
        
        btnApprove.layer.cornerRadius = 25
        btnApprove.layer.borderWidth = 1
        btnApprove.layer.borderColor = UIColor.black.cgColor
        
        btnDisaprove.layer.cornerRadius = 25
        btnDisaprove.layer.borderWidth = 1
        btnDisaprove.layer.borderColor = UIColor.black.cgColor
        
        fNameTxtF.text = fname
        lNameTxtF.text = lname
        emailTxtf.text = email
        phoneTxtF.text = phone
        print(approve!)
        if(approve!){
            approvedLb.isHidden = false
            imgOrg.tintColor = UIColor.systemGreen
            btnApprove.isHidden = true
            btnDisaprove.isHidden = false
        }else{
            approvedLb.isHidden = true
            imgOrg.tintColor = UIColor.gray
            btnApprove.isHidden = false
            btnDisaprove.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnApprovedPressed(_ sender: Any) {
        print("approved pressed")
        guard let token = defaults.string(forKey: "jsonwebtoken") else{
            return
        }
        userViewModel.ApproveOrganisateur(token: token, id: id!);
        approvedLb.isHidden = false
        imgOrg.tintColor = UIColor.green
        btnApprove.isHidden = true
        btnDisaprove.isHidden = false
    }
    
    @IBAction func btnDisaprovePressed(_ sender: Any) {
        print("disapproved pressed")
        guard let token = defaults.string(forKey: "jsonwebtoken") else{
            return
        }
        userViewModel.DisapproveOrganisateur(token: token, id: id!)
        approvedLb.isHidden = true
        imgOrg.tintColor = UIColor.gray
        btnApprove.isHidden = false
        btnDisaprove.isHidden = true
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
