//
//  DetailShareViewController.swift
//  camperTN
//
//  Created by chekir walid on 9/12/2021.
//

import UIKit
import MapKit

class DetailShareViewController: UIViewController {
    var idshare: String?
    var titre: String?
    var emailcreateur: String?
    var emailpartageur: String?
    var latitude: Double?
    var longitude: Double?
    var shareViewModel: ShareViewModel?
    var commentaireViewModel: CommentaireViewModel?
    var count: Int?
    var like: Bool?
    var share: ShareDataUpdate?
    var commentaireData = [CommentaireData]()
    
    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var mapV: MKMapView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var navBarItem: UINavigationItem!
    @IBOutlet weak var barBtnItem: UIBarButtonItem!
    @IBOutlet weak var createurTxtF: UITextField!
    @IBOutlet weak var partageurTxtF: UITextField!
    @IBOutlet weak var numberLikeLB: UILabel!
    @IBOutlet weak var commentaireTXTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableV.dataSource = self
        self.tableV.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)//nibName is the name of the file K.cellNibName =  MessageCell for the design of the message
        commentaireViewModel = CommentaireViewModel()
        loadCommentaireData()
        
        shareViewModel = ShareViewModel()
        share = ShareDataUpdate.init(_id: idshare!, emailcampeur: currentUser.email!)
        loadDataLike()
        
        view1.layer.cornerRadius = 17
        view1.layer.borderWidth = 0.1
        view1.layer.shadowColor = UIColor.lightGray.cgColor
        view1.layer.shadowOpacity = 1
        view1.layer.shadowOffset = .zero
        view1.layer.shadowRadius = 10
        //viewUI.layer.shadowPath = UIBezierPath(rect: viewUI.bounds).cgPath
        view1.layer.shouldRasterize = true
        view1.layer.rasterizationScale = UIScreen.main.scale
        
        view2.layer.cornerRadius = 17
        view2.layer.borderWidth = 0.1
        view2.layer.shadowColor = UIColor.lightGray.cgColor
        view2.layer.shadowOpacity = 1
        view2.layer.shadowOffset = .zero
        view2.layer.shadowRadius = 10
        //viewUI.layer.shadowPath = UIBezierPath(rect: viewUI.bounds).cgPath
        view2.layer.shouldRasterize = true
        view2.layer.rasterizationScale = UIScreen.main.scale
        
        
        navBarItem.title = titre!
        
        createurTxtF.text = emailcreateur!
        partageurTxtF.text = emailpartageur!
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        
        mapV.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapV.setRegion(region, animated: true)
    }
    
    func loadDataLike() {
        shareViewModel?.countLikeAndReturnIsliked(share: share!)
        self.shareViewModel?.bindEventViewModelToController = {
            DispatchQueue.main.async {
                self.count = self.shareViewModel?.likeinfo.count
                self.like = self.shareViewModel?.likeinfo.isliked
                print(self.count!)
                print(self.like!)
                self.numberLikeLB.text = "Number Of like : \(self.count!)"
                if self.like! {
                    self.barBtnItem.image = UIImage(systemName: "suit.heart.fill")
                }else{
                    self.barBtnItem.image = UIImage(systemName: "suit.heart")
                }
            }
        }
    }
    func loadCommentaireData() {
        commentaireViewModel?.getAllCommentaireOfShareEvent(idEvent: idshare!)
        self.commentaireViewModel?.bindEventViewModelToController = {
            DispatchQueue.main.async {
                if let data = self.commentaireViewModel?.commentaireData {
                    self.commentaireData = data
                    print(data)
                    self.tableV.reloadData()
                    //to scroll down automaticaly when send msg or many msg display
                    let indexPath = IndexPath(row: self.commentaireData.count - 1, section: 0)
                    self.tableV.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
    }
    
    
    @IBAction func likeBtnPressed(_ sender: Any) {
        shareViewModel?.updateLikeDislike(share: share!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
           // Code you want to be delayed
            self.loadDataLike()
        }
        
    }
    @IBAction func sendMsgBtnPressed(_ sender: Any) {
        if commentaireTXTF.text == "" {
            //1
            let alert = UIAlertController(title: "Error", message: "you can't send empty commentaire!", preferredStyle: .alert)
            //2
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            //3
            alert.addAction(action)
            //4
            self.present(alert, animated: true, completion: nil)
        }else{
            let commentaire = Commentaire.init(idEvent: idshare, sender: currentUser.email, body: commentaireTXTF.text, date: Date().timeIntervalSince1970)
            commentaireViewModel?.createCommentaire(commentaire: commentaire)
            commentaireTXTF.text = ""
            loadCommentaireData()
        }
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}

extension DetailShareViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(commentaireData.count)
        return commentaireData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell //cell of table and as! MessageCell  to get the design as! to cast the type or convert to the sub class its the down cast
        //and  as to up cast to parent class
        // as! to down cast to child class
        cell.label.text = commentaireData[indexPath.row].body //label in the Message cell created
        
        if commentaireData[indexPath.row].sender == currentUser.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            cell.label.text = commentaireData[indexPath.row].sender!+" : "+commentaireData[indexPath.row].body!
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        return cell
    }
    
    
}
