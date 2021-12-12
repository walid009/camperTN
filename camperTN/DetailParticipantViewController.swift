//
//  DetailParticipantViewController.swift
//  camperTN
//
//  Created by chekir walid on 28/11/2021.
//

import UIKit
import MapKit

class DetailParticipantViewController: UIViewController,UITableViewDataSource {
    var titre: String?
    var listCamper: [UserDataWithNotPassword]?
    var latitude:Double?
    var longitude:Double?
    var nbrParticipant:Int?
    
    @IBOutlet weak var titleTXTF: UITextField!
    @IBOutlet weak var firstUIV: UIView!
    @IBOutlet weak var secondUIV: UIView!
    @IBOutlet weak var tableUIT: UITableView!
    @IBOutlet weak var mapV: MKMapView!
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
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        
        mapV.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapV.setRegion(region, animated: true)
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
    
    
    @IBAction func chartBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showChart", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChart"{
            if let vc = segue.destination as? ChartViewController{
                vc.titreEvent = titre!
                vc.nbreParticipant = nbrParticipant!
            }
        }
    }
    
}
