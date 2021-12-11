//
//  CommentaireViewModel.swift
//  camperTN
//
//  Created by chekir walid on 10/12/2021.
//

import Foundation

class CommentaireViewModel: NSObject{
    //var
    private var apiCommentaire: APICommentaire?
    private(set) var commentaireData : [CommentaireData]! {
        didSet {
            self.bindEventViewModelToController()
        }
    }
    
    /*private(set) var likeinfo : likeData! {
        didSet {
            self.bindEventViewModelToController()
        }
    }*/
    
    var bindEventViewModelToController : (() -> ()) = {
    }
    
    override init() {
        super.init()
        self.apiCommentaire = APICommentaire()
        //getAllEvents()
    }
    
    func createCommentaire(commentaire: Commentaire){
        apiCommentaire?.createCommentaire(commentaire: commentaire, completion: { error in
            print(error ?? "")
        })
    }
    
    func getAllCommentaireOfShareEvent(idEvent: String){
        apiCommentaire?.getAllCommentaireShareEvents(idEvent: idEvent, completion: { commentaireData in
            self.commentaireData = commentaireData
        })
    }
    
}
