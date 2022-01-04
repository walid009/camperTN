//
//  CEventsViewController.swift
//  camperTN
//
//  Created by chekir walid on 8/11/2021.
//

import UIKit

class CEventsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //MARK: -var
    var eventViewModel: EventViewModel?
    var data = [EventData]()
    //let
    let defaults = UserDefaults.standard
    //MARK: -IBOutlet
    @IBOutlet weak var tableEvents: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callToViewModelForUIUpdate()
    }
    
    //MARK: -function
    
    func callToViewModelForUIUpdate(){
        guard let token = defaults.string(forKey: "jsonwebtoken") else{
            return
        }
        print("=======>\(token)")
        eventViewModel = EventViewModel()
        eventViewModel?.getAllEvents(token: token)
        self.eventViewModel!.bindEventViewModelToController = {
            self.updateDataSource()
        }
    }
    
    func updateDataSource(){
        //print(data)
        DispatchQueue.main.async {
            self.data = self.eventViewModel!.eventData
            self.data.reverse()
            self.tableEvents.reloadData()
        }
    }
    
    //MARK: -UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let contentView = cell?.contentView
        
        let label = contentView?.viewWithTag(1) as! UILabel
        let imageView = contentView?.viewWithTag(3) as! UIImageView
        let dateValue = contentView?.viewWithTag(2) as! UIDatePicker
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: data[indexPath.row].date!)
        dateValue.date = date ?? Date()
        
        
        label.text = data[indexPath.row].titre
        let url = URL(string: "\(baseURL)/\(data[indexPath.row].image!)")!
        
        // Fetch Image Data
        if let data = try? Data(contentsOf: url) {
            // Create Image and Update Image View
            imageView.image = UIImage(data: data)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowDetailEvent", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailEvent" {
            let indexPath = sender as! IndexPath
            let event = data[indexPath.row]
            if let vc = segue.destination as? DetailEventViewController {
                vc.titre = event.titre
                vc.desc = event.description
                vc.idEvent = event._id
                vc.latitude = event.Latitude
                vc.longitude = event.Longitude
                vc.emailcreateur = event.emailcreateur
                vc.phone = event.phonecreateur
                vc.price = event.price
                vc.dateValue = event.date!
                vc.image = event.image
            }
        }
    }
    
    //MARK: -IBAction
    @IBAction func LogoutBtnPressed(_ sender: UIBarButtonItem) {
        defaults.setValue("", forKey: "email")
        defaults.removeObject(forKey: "email")
        print("before")
        // Do any additional setup after loading the view.
        
        print("auto login")
        self.navigationController?.navigationBar.isHidden = false
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
