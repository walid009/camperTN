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
    //MARK: -IBOutlet
    @IBOutlet weak var tableEvents: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        callToViewModelForUIUpdate()
        // Do any additional setup after loading the view.
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
        
        label.text = data[indexPath.row].titre
        imageView.image = UIImage(named: "tes")
        
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
            }
        }
    }
    
    //MARK: -IBAction
    @IBAction func LogoutBtnPressed(_ sender: UIBarButtonItem) {
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
