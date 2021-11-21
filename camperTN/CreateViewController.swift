//
//  CreateViewController.swift
//  camperTN
//
//  Created by chekir walid on 6/11/2021.
//

import UIKit

class CreateViewController: UIViewController {
    //MARK: -var
    var eventViewModel = EventViewModel()
    //MARK: -IBOutlet
    @IBOutlet weak var titleLB: UITextField!
    @IBOutlet weak var desciptionTXTV: UITextView!
    @IBOutlet weak var dateDP: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func AddEventBtnPressed(_ sender: Any) {
        if titleLB.text == "" || desciptionTXTV.text == "" {
            let alert = UIAlertController(title: "Error", message: "Complete All Field !", preferredStyle: .alert)
            //2
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            //3
            alert.addAction(action)
            //4
            self.present(alert, animated: false, completion: nil)
        }else{
            let event = Event.init(titre: titleLB.text ?? "", description: desciptionTXTV.text ?? "", position: nil, createur: nil, participants: nil)
            eventViewModel.createEvent(eventToCreate: event)
            let alert = UIAlertController(title: "Success", message: "Event Created", preferredStyle: .alert)
            //2
            let action = UIAlertAction(title: "OK", style: .default,handler: { UIAlertAction in
                self.desciptionTXTV.text = ""
                self.titleLB.text = ""
            })
            //3
            alert.addAction(action)
            //4
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
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
