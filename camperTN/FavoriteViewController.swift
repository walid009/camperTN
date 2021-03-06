//
//  FavoriteViewController.swift
//  camperTN
//
//  Created by chekir walid on 8/11/2021.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var events = [EventCore]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LoadData()
        tableView.reloadData()
    }
    
    func LoadData(with request: NSFetchRequest<EventCore> = EventCore.fetchRequest()) {
        //with when we call method and request used in the method value if no data passed to the method is Favorites.fetchRequest()
        do {
            events = try self.context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let context = cell.contentView
        
        let imageUIV = context.viewWithTag(1) as! UIImageView
        let label1 = context.viewWithTag(2) as! UILabel
        let dateValue = context.viewWithTag(3) as! UIDatePicker
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: events[indexPath.row].date!)
        dateValue.date = date ?? Date()
        //let label2 = context.viewWithTag(3) as! UILabel
        
        label1.text = events[indexPath.row].titre
        let url = URL(string: "\(baseURL)/\(events[indexPath.row].image!)")!
        
        // Fetch Image Data
        if let data = try? Data(contentsOf: url) {
            // Create Image and Update Image View
            imageUIV.image = UIImage(data: data)
        }
        print("======================"+events[indexPath.row].emailcreateur!)
        print(events[indexPath.row].emailpartageur!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(events[indexPath.row].titre!)
        self.performSegue(withIdentifier: "showDetailFavorite", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailFavorite" {
            let indexPath = sender as! IndexPath
            let event = events[indexPath.row]
            if let vc = segue.destination as? DetailFavoriteViewController {
                vc.titre = event.titre
                vc.desc = event.desc
                vc.idEvent = event.id
                vc.latitude = event.latitude
                vc.longitude = event.longitude
                vc.emailcreateur = event.emailcreateur
                vc.emailpartageur = event.emailpartageur
                vc.shared = event.shared
                vc.dateValue = event.date
                vc.image = event.image
            }
        }
    }
    let defaults = UserDefaults.standard
    @IBAction func logoutBtnPRessed(_ sender: Any) {
        defaults.setValue("", forKey: "email")
        defaults.removeObject(forKey: "email")
        print("before")
        // Do any additional setup after loading the view.
        
        print("auto login")
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popViewController(animated: false)
    }
}
