//
//  DetailEventViewController.swift
//  camperTN
//
//  Created by chekir walid on 8/11/2021.
//

import UIKit

class DetailEventViewController: UIViewController {
    var idEvent: String?
    var titre: String?
    var desc: String?
    var eventViewModel: EventViewModel?
    var exist:Bool?
    
    @IBOutlet weak var titreTxtF: UITextField!
    @IBOutlet weak var descriptionTxtF: UITextView!
    @IBOutlet weak var viewUI: UIView!
    @IBOutlet weak var participateBTN: UIButton!
    @IBOutlet weak var favoriteBTN: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventViewModel = EventViewModel()
        viewUI.layer.cornerRadius = 17
        viewUI.layer.borderWidth = 0.1
        viewUI.layer.shadowColor = UIColor.lightGray.cgColor
        viewUI.layer.shadowOpacity = 1
        viewUI.layer.shadowOffset = .zero
        viewUI.layer.shadowRadius = 10
        //viewUI.layer.shadowPath = UIBezierPath(rect: viewUI.bounds).cgPath
        viewUI.layer.shouldRasterize = true
        viewUI.layer.rasterizationScale = UIScreen.main.scale
        
        participateBTN.layer.cornerRadius = 25
        participateBTN.layer.borderWidth = 1
        participateBTN.layer.borderColor = UIColor.black.cgColor
        
        favoriteBTN.layer.cornerRadius = 25
        favoriteBTN.layer.borderWidth = 1
        favoriteBTN.layer.borderColor = UIColor.black.cgColor
        
        titreTxtF.text = titre!
        descriptionTxtF.text = desc!
        // Do any additional setup after loading the view.
        print(idEvent!)
        print(currentUser.email!)
    }
    
    @IBAction func ParticiperBtnPressed(_ sender: UIButton) {
    }
    
    @IBAction func FavoriteBtnPressed(_ sender: UIButton) {
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    @IBAction func participateBtnPressed(_ sender: Any) {
        callToViewModelForCheckUserParticipate()
    }
    
    func callToViewModelForCheckUserParticipate(){
        eventViewModel?.checkUserExistInEvent(id: idEvent!, email: currentUser.email!)
        self.eventViewModel?.bindEventViewModelToController = {
            DispatchQueue.main.async {
                self.exist = self.eventViewModel?.existUserParticipate.exist
                print(self.exist!)
                if self.exist != nil {
                    if self.exist! {
                        //1
                        let alert = UIAlertController(title: "Impossible", message: "You already Participate to this event \(self.exist!)", preferredStyle: .alert)
                        //2
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        //3
                        alert.addAction(action)
                        //4
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        print("you can participate")
                        let alert = UIAlertController(title: "\(self.titre!)", message: "Are you sure to participate To this Event \(self.titre!)", preferredStyle: .alert)
                        //2
                        let cancel = UIAlertAction(title: "No", style: .cancel)
                        let action = UIAlertAction(title: "Yes", style: .default) { UIAlertAction in
                            let user = UserDataWithNotPassword.init(_id: currentUser._id!, nom: currentUser.nom!, prenom: currentUser.prenom!, email: currentUser.email!, role: currentUser.role!, telephone: currentUser.telephone!)
                            self.eventViewModel?.participateUserToEvent(idEvent: self.idEvent!, user: user)
                        }
                        //3
                        alert.addAction(action)
                        alert.addAction(cancel)
                        //4
                        self.present(alert, animated: true, completion: nil)
                        //print(self.idEvent!)
                        //print(user)
                    }
                }
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
