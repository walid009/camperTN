//
//  ListOrganisateurViewController.swift
//  camperTN
//
//  Created by chekir walid on 29/12/2021.
//

import UIKit

class ListOrganisateurViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    //MARK: -var
    var userViewModel: UserViewModel?
    var data = [UserInfoLogin]()
    //let
    let defaults = UserDefaults.standard
    @IBOutlet weak var usersTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callToViewModelForUIUpdate()
        //print(data)
    }
    
    //MARK: -function
    
    func callToViewModelForUIUpdate(){
        guard let token = defaults.string(forKey: "jsonwebtoken") else{
            return
        }
        print("=======>\(token)")
        userViewModel = UserViewModel()
        userViewModel?.getAllOrganisateurUsers(token: token)
        self.userViewModel!.bindUserViewModelToController = {
            self.updateDataSource()
        }
    }
    
    func updateDataSource(){
        //print(data)
        DispatchQueue.main.async {
            self.data = self.userViewModel!.orgUsersData
            self.usersTable.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let contentView = cell?.contentView
        //widgets
        let email = contentView?.viewWithTag(1) as! UITextField
        let tel = contentView?.viewWithTag(2) as! UITextField
        
        email.text = data[indexPath.row].email
        tel.text = data[indexPath.row].telephone
        
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowDetailOrg", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailOrg"{
            let indexPath = sender as! IndexPath
            let users = data[indexPath.row]
            if let vc = segue.destination as? detailOrganisateurViewController{
                vc.id = users._id
                vc.fname = users.prenom
                vc.lname = users.nom
                vc.email = users.email
                vc.approve = users.approved
                vc.phone = users.telephone
            }
        }
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        defaults.setValue("", forKey: "email")
        defaults.removeObject(forKey: "email")
        print("before")
        // Do any additional setup after loading the view.
        
        print("auto login")
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popViewController(animated: false)
    }
    
}
