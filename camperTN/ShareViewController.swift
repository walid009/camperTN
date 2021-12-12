//
//  ShareViewController.swift
//  camperTN
//
//  Created by chekir walid on 8/11/2021.
//

import UIKit

class ShareViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    var shareViewModel: ShareViewModel?
    var data = [shareEventData]()

    @IBOutlet weak var tableV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callToViewModelForUIUpdate()
        //print(data)
    }
    
    //MARK: -function
    
    func callToViewModelForUIUpdate(){
        shareViewModel = ShareViewModel()
        shareViewModel?.getAllEvents()
        self.shareViewModel!.bindEventViewModelToController = {
            DispatchQueue.main.async {
                self.data = self.shareViewModel!.shareData
                self.tableV.reloadData()
            }

        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(data.count)
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let contentView = cell?.contentView
        //widgets
        let imageView = contentView?.viewWithTag(1) as! UIImageView
        let label = contentView?.viewWithTag(2) as! UILabel
        //bind
        label.text = data[indexPath.row].titre
        imageView.image = UIImage(named: "tes")
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(data[indexPath.row].titre!)
        self.performSegue(withIdentifier: "showDetailSharecc", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSharecc" {
            let indexPath = sender as! IndexPath
            let event = data[indexPath.row]
            if let vc = segue.destination as? DetailShareViewController {
                vc.titre = event.titre
                vc.emailcreateur = event.emailcreateur
                vc.emailpartageur = event.emailpartageur
                vc.latitude = event.Latitude
                vc.longitude = event.Longitude
                vc.idshare = event._id
            }
        }
    }

    @IBAction func logoutBtnPRessed(_ sender: Any) {
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
