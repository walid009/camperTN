//
//  DetailEventViewController.swift
//  camperTN
//
//  Created by chekir walid on 8/11/2021.
//

import UIKit
import MapKit
import CoreData
import Braintree

class DetailEventViewController: UIViewController {
    var idEvent: String?
    var titre: String?
    var desc: String?
    var eventViewModel: EventViewModel?
    var exist:Bool?
    var latitude:Double?
    var longitude:Double?
    var emailcreateur: String?
    var braintreeClient: BTAPIClient!
    var phone: String?
    var price: String?
    var dateValue: String?
    var image:String?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var viewUI1: UIView!
    @IBOutlet weak var phoneTxtF: UITextField!
    @IBOutlet weak var emailTxtF: UITextField!
    @IBOutlet weak var titreTxtF: UITextField!
    @IBOutlet weak var descriptionTxtF: UITextView!
    @IBOutlet weak var viewUI: UIView!
    @IBOutlet weak var participateBTN: UIButton!
    @IBOutlet weak var favoriteBTN: UIButton!
    @IBOutlet weak var mapV: MKMapView!
    @IBOutlet weak var priceLB: UILabel!
    @IBOutlet weak var dateDP: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        priceLB.text = "Price : \(price!).0 DT"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateValue!)
        dateDP.date = date ?? Date()
        
        eventViewModel = EventViewModel()
        
        viewUI1.layer.cornerRadius = 17
        viewUI1.layer.borderWidth = 0.1
        viewUI1.layer.shadowColor = UIColor.lightGray.cgColor
        viewUI1.layer.shadowOpacity = 1
        viewUI1.layer.shadowOffset = .zero
        viewUI1.layer.shadowRadius = 10
        //viewUI.layer.shadowPath = UIBezierPath(rect: viewUI.bounds).cgPath
        viewUI1.layer.shouldRasterize = true
        viewUI1.layer.rasterizationScale = UIScreen.main.scale
        
        emailTxtF.text = emailcreateur!
        phoneTxtF.text = phone!
        
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
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        
        mapV.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapV.setRegion(region, animated: true)
        
        self.braintreeClient = BTAPIClient(authorization: "sandbox_f252zhq7_hh4cpc39zq4rgjcg")
    }
    
    @IBAction func ParticiperBtnPressed(_ sender: UIButton) {
    }
    
    @IBAction func FavoriteBtnPressed(_ sender: UIButton) {
        if check() {
            let alert = UIAlertController(title: "Error", message: "Already added to you're favortie", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }else{
            let entityDescription = NSEntityDescription.entity(forEntityName: "EventCore", in: context)
            
            let object = NSManagedObject(entity: entityDescription!, insertInto: context)
            
            object.setValue(idEvent!, forKey: "id")
            object.setValue(titre!, forKey: "titre")
            object.setValue(desc!, forKey: "desc")
            object.setValue(latitude!, forKey: "latitude")
            object.setValue(longitude!, forKey: "longitude")
            object.setValue(emailcreateur!, forKey: "emailcreateur")
            object.setValue(currentUser.email!, forKey: "emailpartageur")
            object.setValue(false, forKey: "shared")
            object.setValue(image!, forKey: "image")
            object.setValue(dateValue!, forKey: "date")
            saveItems()
            let alert = UIAlertController(title: "Susscess", message: "Event \(titre!) added successfully to you're favortie", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    func check() -> Bool {
        let request = NSFetchRequest<NSManagedObject>(entityName: "EventCore")
        let predicate = NSPredicate(format: "id like %@", idEvent!)
        request.predicate = predicate
        
        do{
            let result = try context.fetch(request)
            if result.count > 0 {
                return true
            }
        }catch{
            print("error fetch")
            return false
        }
        return false
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
                            let payPalDriver = BTPayPalDriver(apiClient: self.braintreeClient)
                            // Important! Choose either Vault or Checkout flow
                            // Start the Vault flow, or...
                            let vaultRequest = BTPayPalVaultRequest()
                            payPalDriver.tokenizePayPalAccount(with: vaultRequest) { (tokenizedPayPalAccount, error) in
                                // ...
                                print("laba")
                            }
                            // ...start the Checkout flow
                            let checkoutRequest = BTPayPalCheckoutRequest(amount: "\(self.price!).00")
                            payPalDriver.tokenizePayPalAccount(with: checkoutRequest) { (tokenizedPayPalAccount, error) in
                                print("ici")
                                if tokenizedPayPalAccount != nil {
                                    let user = UserDataWithNotPassword.init(_id: currentUser._id!, nom: currentUser.nom!, prenom: currentUser.prenom!, email: currentUser.email!, role: currentUser.role!, telephone: currentUser.telephone!, approved: false)
                                    self.eventViewModel?.participateUserToEvent(idEvent: self.idEvent!, user: user)
                                    print("payer avec success")
                                }
                            }
                            
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

}
