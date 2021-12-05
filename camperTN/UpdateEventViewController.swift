//
//  UpdateViewController.swift
//  camperTN
//
//  Created by chekir walid on 9/11/2021.
//

import UIKit
import MapKit

class UpdateEventViewController: UIViewController {
    //MARK: -var
    var titre: String?
    var desc: String?
    var id: String?
    var eventViewModel: EventViewModel?
    var latitude:Double?
    var longitude:Double?
    //MARK: -IBOutlet
    @IBOutlet weak var titreLB: UITextField!
    @IBOutlet weak var descTxt: UITextView!
    @IBOutlet weak var viewUI: UIView!
    @IBOutlet weak var updateBTN: UIButton!
    @IBOutlet weak var mapV: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewUI.layer.cornerRadius = 17
        viewUI.layer.borderWidth = 0.1
        viewUI.layer.shadowColor = UIColor.lightGray.cgColor
        viewUI.layer.shadowOpacity = 1
        viewUI.layer.shadowOffset = .zero
        viewUI.layer.shadowRadius = 10
        //viewUI.layer.shadowPath = UIBezierPath(rect: viewUI.bounds).cgPath
        viewUI.layer.shouldRasterize = true
        viewUI.layer.rasterizationScale = UIScreen.main.scale
        
        updateBTN.layer.cornerRadius = 25
        updateBTN.layer.borderWidth = 1
        updateBTN.layer.borderColor = UIColor.black.cgColor

        titreLB.text = titre
        descTxt.text = desc
        print(id ?? "no id")
        eventViewModel = EventViewModel()
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        
        mapV.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapV.setRegion(region, animated: true)
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func BackBtnPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func UpdateBtnPressed(_ sender: UIButton) {
        let x = titreLB.text
        let y = descTxt.text
        if x == "" || y == "" {
            let alert = UIAlertController(title: "Error", message: "Complete All Field !", preferredStyle: .alert)
            //2
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            //3
            alert.addAction(action)
            //4
            self.present(alert, animated: false, completion: nil)
        }else{
            let event = EventDataUpdate.init(_id: id!, titre: x!, description: y!)
            eventViewModel?.updateEvent(eventToUpdate: event)
            self.navigationController?.popViewController(animated: false)
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
