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
        eventViewModel?.getAllEvents(token: token)
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
        //bind
        label.text = data[indexPath.row].titre
        imageView.image = UIImage(named: "tes")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let event = EventID.init(_id: data[indexPath.row]._id!)
            eventViewModel?.deleteEvent(eventToDelete: event)
            data.remove(at: indexPath.row)
            tableView.reloadData()
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
            }
        }
        if segue.identifier == "showDetailParticipate"{
            let indexPath = sender as! IndexPath
            let event = data[indexPath.row]
            if let vc = segue.destination as? DetailParticipantViewController{
                vc.titre = event.titre
                vc.listCamper = event.participants
            }
        }
    }
    
    //MARK: -IBAction
    
    @IBAction func LougoutButtonPressed(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popViewController(animated: false)
    }
    
}
