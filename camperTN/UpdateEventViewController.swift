//
//  UpdateViewController.swift
//  camperTN
//
//  Created by chekir walid on 9/11/2021.
//

import UIKit

class UpdateEventViewController: UIViewController {
    //MARK: -var
    var titre: String?
    var desc: String?
    var id: String?
    var eventViewModel: EventViewModel?
    //MARK: -IBOutlet
    @IBOutlet weak var titreLB: UITextField!
    @IBOutlet weak var descTxt: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titreLB.text = titre
        descTxt.text = desc
        print(id ?? "no id")
        eventViewModel = EventViewModel()
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func BackBtnPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func UpdateBtnPressed(_ sender: UIButton) {
        let x = titreLB.text
        let y = descTxt.text
        let event = EventDataUpdate.init(_id: id!, titre: x!, description: y!)
        eventViewModel?.updateEvent(eventToUpdate: event)
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
