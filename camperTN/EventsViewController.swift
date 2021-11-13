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
    //MARK: -IBOutlet
    @IBOutlet weak var eventTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callToViewModelForUIUpdate()
    }
    
    //MARK: -function
    
    func callToViewModelForUIUpdate(){
        eventViewModel = EventViewModel()
        eventViewModel?.getAllEvents()
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
       // let editBTN = contentView?.viewWithTag(4) as! UIButton
       // let deleteBTN = contentView?.viewWithTag(5) as! UIButton
        //bind
        label.text = data[indexPath.row].titre
        imageView.image = UIImage(named: "tes")
       /* deleteBTN.tag = indexPath.row
        deleteBTN.addTarget(self, action: #selector(EventsViewController.DeleteBtnPressed(sender:)), for: .touchUpInside)*/
        
        //print("==>\(data[indexPath.row].titre)")
        return cell!
    }
    
    /*@objc func DeleteBtnPressed(sender: Int) {
        
        print(sender)
    }*/
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let event = EventID.init(_id: data[indexPath.row]._id!)
            eventViewModel?.deleteEvent(eventToDelete: event)
            data.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(data[indexPath.row].titre)
        self.performSegue(withIdentifier: "ShowUpdateEvent", sender: indexPath)
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
    }
    
    //MARK: -IBAction
    
    @IBAction func LougoutButtonPressed(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popViewController(animated: false)
    }
    
}
