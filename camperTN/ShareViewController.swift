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
        let dateValue = contentView?.viewWithTag(3) as! UIDatePicker
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
