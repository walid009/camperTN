//
//  DetailEventViewController.swift
//  camperTN
//
//  Created by chekir walid on 8/11/2021.
//

import UIKit

class DetailEventViewController: UIViewController {
    var titre: String?
    var desc: String?
    @IBOutlet weak var titreLB: UILabel!
    @IBOutlet weak var dateLB: UILabel!
    @IBOutlet weak var descriptionLB: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titreLB.text = titre!
        descriptionLB.text = desc!
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ParticiperBtnPressed(_ sender: UIButton) {
    }
    
    @IBAction func FavoriteBtnPressed(_ sender: UIButton) {
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
