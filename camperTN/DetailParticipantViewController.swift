//
//  DetailParticipantViewController.swift
//  camperTN
//
//  Created by chekir walid on 28/11/2021.
//

import UIKit

class DetailParticipantViewController: UIViewController,UITableViewDataSource {
    var titre: String?
    var listCamper: [UserDataWithNotPassword]?
    
    @IBOutlet weak var titleTXTF: UITextField!
    @IBOutlet weak var firstUIV: UIView!
    @IBOutlet weak var secondUIV: UIView!
    @IBOutlet weak var tableUIT: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        firstUIV.layer.cornerRadius = 17
        firstUIV.layer.borderWidth = 0.1
        firstUIV.layer.shadowColor = UIColor.lightGray.cgColor
        firstUIV.layer.shadowOpacity = 1
        firstUIV.layer.shadowOffset = .zero
        firstUIV.layer.shadowRadius = 10
        firstUIV.layer.shouldRasterize = true
        firstUIV.layer.rasterizationScale = UIScreen.main.scale
        
        secondUIV.layer.cornerRadius = 17
        secondUIV.layer.borderWidth = 0.1
        secondUIV.layer.shadowColor = UIColor.lightGray.cgColor
        secondUIV.layer.shadowOpacity = 1
        secondUIV.layer.shadowOffset = .zero
        secondUIV.layer.shadowRadius = 10
        secondUIV.layer.shouldRasterize = true
        secondUIV.layer.rasterizationScale = UIScreen.main.scale

        titleTXTF.text = titre!
        title = titre!
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCamper!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let contentView = cell?.contentView
        //widgets
        let email = contentView?.viewWithTag(1) as! UITextField
        let phone = contentView?.viewWithTag(2) as! UITextField
        //bind
        email.text = listCamper![indexPath.row].email
        phone.text = listCamper![indexPath.row].telephone
        return cell!
    }

    @IBAction func backBtnPressed(_ sender: Any) {
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
