//
//  ShareViewModel.swift
//  camperTN
//
//  Created by chekir walid on 9/12/2021.
//

import Foundation

class ShareViewModel: NSObject{
    //var
    private var apiShare: APIShare?
    //private var apiRequest=APIRequest.init(url: "http://localhost:3000/events/create")
    private(set) var shareData : [shareEventData]! {
        didSet {
            self.bindEventViewModelToController()
        }
    }
    
    private(set) var likeinfo : likeData! {
        didSet {
            self.bindEventViewModelToController()
        }
    }
    
    var bindEventViewModelToController : (() -> ()) = {
    }
    
    override init() {
        super.init()
        self.apiShare = APIShare()
        //getAllEvents()
    }
    
    func getAllEvents() {
        self.apiShare?.getShareEvents(completion: { shareEventData in
            self.shareData = shareEventData
        })
    }
    
    func createShareEvent(share: shareEvent){
        apiShare?.createShare(share: share, completion: { error in
            print(error ?? "")
        })
    }
    
    func updateLikeDislike(share: ShareDataUpdate){
        apiShare?.updateLikeDislike(share: share, completion: { error in
            print(error ?? "success")
        })
    }
        
    func countLikeAndReturnIsliked(share: ShareDataUpdate) {
        apiShare?.countLikeAndReturnIsliked(share: share, completion: { likeData in
            self.likeinfo = likeData
        })
    }
    
}
