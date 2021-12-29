//
//  OrganisateurEventsViewController.swift
//  camperTN
//
//  Created by chekir walid on 2/11/2021.
//

import UIKit

class EventsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    //MARK: -var
    var eventViewModel: EventViewModel?
    var data = [EventData]()
    //let
    let defaults = UserDefaults.standard
    //MARK: -IBOutlet
    @IBOutlet weak var eventTable: UITableView!
    
    @IBOutlet weak var dateDP: UIDatePicker!
    var exist:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callToViewModelForUIUpdate()
        //print(data)
    }
    
    //MARK: -function
    
    func callToViewModelForUIUpdate(){
        guard let token = defaults.string(forKey: "jsonwebtoken") else{
            return
        }
        print("=======>\(token)")
        eventViewModel = EventViewModel()
        eventViewModel?.getAllEventsCreatedByOrganisteur(email: currentUser.email!, token: token)
        self.eventViewModel!.bindEventViewModelToController = {
            self.updateDataSource()
        }
    }
    
    func updateDataSource(){
        //print(data)
        DispatchQueue.main.async {
            self.data = self.eventViewModel!.eventData
            self.eventTable.reloadData()
        }
    }
    
    //MARK: -table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(data.count)
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") 
        let contentView = cell?.contentView
        //widgets
        let label = contentView?.viewWithTag(1) as! UILabel
        let imageView = contentView?.viewWithTag(3) as! UIImageView
        let dateValue = contentView?.viewWithTag(2) as! UIDatePicker
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: data[indexPath.row].date!)
        dateValue.date = date ?? Date()
        
        
        //bind
        label.text = data[indexPath.row].titre
        let url = URL(string: "http://localhost:3000/\(data[indexPath.row].image!)")!
        
        // Fetch Image Data
        if let data = try? Data(contentsOf: url) {
            // Create Image and Update Image View
            imageView.image = UIImage(data: data)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            eventViewModel?.checkIfUsersExistInEventForDeleteThisEvent(id: self.data[indexPath.row]._id!)
            self.eventViewModel?.bindEventViewModelToController = {
                DispatchQueue.main.async {
                    self.exist = self.eventViewModel?.existUsersInEvent.usersExist
                    print(self.exist!)
                    if self.exist != nil {
                        if self.exist! {
                            //1
                            let alert = UIAlertController(title: "Impossible", message: "Users participate to this event to late to delete it !", preferredStyle: .alert)
                            //2
                            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                            //3
                            alert.addAction(action)
                            //4
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            let alert = UIAlertController(title: "Delete", message: "Are you sure to participate To this Event \(self.data[indexPath.row].titre)", preferredStyle: .alert)
                            //2
                            let cancel = UIAlertAction(title: "No", style: .default)
                            let action = UIAlertAction(title: "Yes", style: .destructive) { UIAlertAction in
                                let event = EventID.init(_id: self.data[indexPath.row]._id!)
                                self.eventViewModel?.deleteEvent(eventToDelete: event)
                                self.data.remove(at: indexPath.row)
                                tableView.reloadData()
                            }
                            //3
                            alert.addAction(cancel)
                            alert.addAction(action)
                            //4
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Edit") { (action, view, completionHandler) in
            self.performSegue(withIdentifier: "ShowUpdateEvent", sender: indexPath)
            completionHandler(true)
        }
        action.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetailParticipate", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUpdateEvent"{
            let indexPath = sender as! IndexPath
            let event = data[indexPath.row]
            if let vc = segue.destination as? UpdateEventViewController{
                vc.id = event._id
                vc.titre = event.titre
                vc.desc = event.description
                vc.latitude = event.Latitude
                vc.longitude = event.Longitude
                vc.dateValue = event.date
            }
        }
        if segue.identifier == "showDetailParticipate"{
            let indexPath = sender as! IndexPath
            let event = data[indexPath.row]
            if let vc = segue.destination as? DetailParticipantViewController{
                vc.titre = event.titre
                vc.listCamper = event.participants
                vc.latitude = event.Latitude
                vc.longitude = event.Longitude
                if event.participants != nil {
                    vc.nbrParticipant = event.participants?.count
                }else{
                    vc.nbrParticipant = 0
                }
            }
        }
    }
    
    //MARK: -IBAction
    
    @IBAction func LougoutButtonPressed(_ sender: Any) {
        defaults.setValue("", forKey: "email")
        defaults.removeObject(forKey: "email")
        print("before")
        // Do any additional setup after loading the view.
        
        print("auto login")
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popViewController(animated: false)
    }
    
}
