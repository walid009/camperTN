//
//  DetailFavoriteViewController.swift
//  camperTN
//
//  Created by chekir walid on 5/12/2021.
//

import UIKit
import MapKit
import CoreData

class DetailFavoriteViewController: UIViewController {
    var idEvent: String?
    var titre: String?
    var desc: String?
    var shareViewModel: ShareViewModel?
    var exist:Bool?
    var latitude:Double?
    var longitude:Double?
    var emailcreateur: String?
    var emailpartageur: String?
    var shared:Bool?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var mapV: MKMapView!
    @IBOutlet weak var titreTxtF: UITextField!
    @IBOutlet weak var descTxtV: UITextView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var RemoveBtn: UIButton!
    @IBOutlet weak var viewUIV: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareViewModel = ShareViewModel()
        
        if shared! == false {
            shareBtn.isEnabled = true
        }else{
            shareBtn.isEnabled = false
            shareBtn.backgroundColor = UIColor.lightGray
        }
        
        viewUIV.layer.cornerRadius = 17
        viewUIV.layer.borderWidth = 0.1
        viewUIV.layer.shadowColor = UIColor.lightGray.cgColor
        viewUIV.layer.shadowOpacity = 1
        viewUIV.layer.shadowOffset = .zero
        viewUIV.layer.shadowRadius = 10
        //viewUI.layer.shadowPath = UIBezierPath(rect: viewUI.bounds).cgPath
        viewUIV.layer.shouldRasterize = true
        viewUIV.layer.rasterizationScale = UIScreen.main.scale
        
        shareBtn.layer.cornerRadius = 25
        shareBtn.layer.borderWidth = 1
        shareBtn.layer.borderColor = UIColor.black.cgColor
        
        RemoveBtn.layer.cornerRadius = 25
        RemoveBtn.layer.borderWidth = 1
        RemoveBtn.layer.borderColor = UIColor.black.cgColor
        
        titreTxtF.text = titre!
        descTxtV.text = desc!
        // Do any additional setup after loading the view.
        print(idEvent!)
        print(currentUser.email!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        
        mapV.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapV.setRegion(region, animated: true)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        let share = shareEvent.init(titre: titre!, description: desc!, Longitude: longitude!, Latitude: latitude!, emailcreateur: emailcreateur!, emailpartageur: emailpartageur!)
        shareViewModel?.createShareEvent(share: share)
        shareBtn.isEnabled = false
        shareBtn.backgroundColor = UIColor.lightGray
    }
    
    func saveItems() {
        if context.hasChanges {
            do {
                try self.context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error, \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    @IBAction func RemoveBtnPressed(_ sender: Any) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "EventCore")
        let predicate = NSPredicate(format: "id like %@", idEvent!)
        request.predicate = predicate
        
        var movieExist: NSManagedObject?
        do{
            let result = try context.fetch(request)
            if result.count > 0{
                movieExist = result[0]
            }
        }catch{
            print("error fetch")
        }
        
        context.delete(movieExist!)///
        if context.hasChanges {
            do{
                try context.save()
            }catch{
                print("error save")
            }
        }
        self.navigationController?.popViewController(animated: false)
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
