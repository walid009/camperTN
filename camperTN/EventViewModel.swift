//
//  EventViewModel.swift
//  camperTN
//
//  Created by chekir walid on 4/11/2021.
//

import Foundation
import UIKit

class EventViewModel: NSObject{
    //var
    private var apiEvent: APIEvent?
    //private var apiRequest=APIRequest.init(url: "http://localhost:3000/events/create")
    private(set) var eventData : [EventData]! {
        didSet {
            self.bindEventViewModelToController()
        }
    }
    
    private(set) var existUserParticipate : EmailExist! {
        didSet {
            self.bindEventViewModelToController()
        }
    }
    
    private(set) var existUsersInEvent : checkUsersInEventForDelete! {
        didSet {
            self.bindEventViewModelToController()
        }
    }
    var bindEventViewModelToController : (() -> ()) = {
    }
    
    override init() {
        super.init()
        self.apiEvent = APIEvent()
        //getAllEvents()
    }
    
    func getAllEvents(token: String) {
        self.apiEvent!.getEvents(token: token) { eventData in
            self.eventData = eventData
            //print(eventData)
        }
    }
    
    func getAllEventsCreatedByOrganisteur(email: String,token: String) {
        self.apiEvent!.getEventsCreatedBy(email: email, token: token) { eventData in
            self.eventData = eventData
            //print(eventData)
        }
    }
    
    func createEventImage(img: UIImage, event: Event){
        apiEvent?.createEventImage(image: img, event: event, completion: { error in
            print(error ?? "success")
        })
    }
    
    func updateEvent(eventToUpdate: EventDataUpdate){
        apiEvent?.updateEvent(event: eventToUpdate, completion: { error in
            print(error ?? "succes update hhhh")
        })
    }
    
    func deleteEvent(eventToDelete: EventID){
        apiEvent?.deleteEvent(event: eventToDelete, completion: { error in
            print(error ?? "success delete haha")
        })
    }
    
    func checkUserExistInEvent(id: String,email: String) {
        apiEvent?.CheckUserAlreadyParticipate(id: id, email: email, completion: { EmailExist in
            self.existUserParticipate = EmailExist
        })
    }
    
    func participateUserToEvent(idEvent:String,user: UserDataWithNotPassword){
        apiEvent?.updateEventWithUserParticipate(idEvent: idEvent, user: user, completion: { error in
            print(error ?? "dddzze")
        })
    }
    
    func checkIfUsersExistInEventForDeleteThisEvent(id: String) {
        apiEvent?.UsersParticipateTothisEvent(id: id, completion: { checkUsersInEventForDelete in
            self.existUsersInEvent = checkUsersInEventForDelete
        })
    }
}
