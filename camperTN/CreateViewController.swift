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
        let event = Event.init(titre: titleLB.text ?? "", description: desciptionTXTV.text ?? "", position: nil, createur: nil, participants: nil)
        eventViewModel.createEvent(eventToCreate: event)
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