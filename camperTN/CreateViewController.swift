//
//  CreateViewController.swift
//  camperTN
//
//  Created by chekir walid on 6/11/2021.
//

import UIKit
import MapKit
import SwiftUI

class CreateViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    //MARK: -var
    var eventViewModel = EventViewModel()
    var latitude:Double?
    var longitude:Double?
    var imageSelected: Bool = false
    //MARK: -IBOutlet
    @IBOutlet weak var titleLB: UITextField!
    @IBOutlet weak var desciptionTXTV: UITextView!
    @IBOutlet weak var dateDP: UIDatePicker!
    @IBOutlet weak var addBTN: UIButton!
    @IBOutlet weak var viewUI: UIView!
    @IBOutlet weak var mapV: MKMapView!
    @IBOutlet weak var imageV: UIImageView!
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
        
        addBTN.layer.cornerRadius = 25
        addBTN.layer.borderWidth = 1
        addBTN.layer.borderColor = UIColor.black.cgColor
        //self.navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
        
        /*let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: -37.82, longitude: 145.04)
        
        mapV.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapV.setRegion(region, animated: true)*/
        mapV.delegate = self
    }
    
    let annotation = MKPointAnnotation()
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        print("cc")
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("zz")
        annotation.coordinate = CLLocationCoordinate2D(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        mapV.addAnnotation(annotation)
        print(mapV.centerCoordinate.latitude)
        print(mapV.centerCoordinate.longitude)
        latitude = mapV.centerCoordinate.latitude
        longitude = mapV.centerCoordinate.longitude
        /*let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapV.setRegion(region, animated: true)*/
    }
    
    /*func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView)
    {
        print("work")
        if let annotationTitle = view.annotation?.title
        {
            print("User tapped on annotation with title: \(annotationTitle!)")
        }
    }*/
    
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
            if latitude != nil && longitude != nil {
                if imageSelected {
                    let pos = Position.init(Longitude: longitude!, Latitude: latitude!)
                    let event = Event.init(titre: titleLB.text ?? "", description: desciptionTXTV.text ?? "", position: pos, emailcreateur: currentUser.email ?? "", participants: nil, phonecreateur: currentUser.telephone!)
                    print(imageV.image?.pngData() ?? "no imagggg")
                    eventViewModel.createEventImage(img: imageV.image!,event: event)
                    //eventViewModel.createEvent(eventToCreate: event)
                    let alert = UIAlertController(title: "Success", message: "Event Created", preferredStyle: .alert)
                    //2
                    let action = UIAlertAction(title: "OK", style: .default,handler: { UIAlertAction in
                        self.desciptionTXTV.text = ""
                        self.titleLB.text = ""
                        self.imageV.isHidden = true
                    })
                    //3
                    alert.addAction(action)
                    //4
                    self.present(alert, animated: false, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Error", message: "You need to upload an image !", preferredStyle: .alert)
                    //2
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    //3
                    alert.addAction(action)
                    //4
                    self.present(alert, animated: false, completion: nil)
                }
            }else{
                let alert = UIAlertController(title: "Error", message: "You need to select the position of the event !", preferredStyle: .alert)
                //2
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                //3
                alert.addAction(action)
                //4
                self.present(alert, animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func uploadBtnPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagePicker = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageV.isHidden = false
        imageV.image = imagePicker
        imageSelected = true
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}
