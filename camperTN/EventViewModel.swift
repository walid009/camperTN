//
//  EventViewModel.swift
//  camperTN
//
//  Created by chekir walid on 4/11/2021.
//

import Foundation

class EventViewModel: NSObject{
    //var
    private var apiEvent: APIEvent?
    //private var apiRequest=APIRequest.init(url: "http://localhost:3000/events/create")
    private(set) var eventData : [EventData]! {
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
    
    func getAllEvents() {
        self.apiEvent!.getEvents { eventData in
            self.eventData = eventData
        }
    }
    
    func createEvent(eventToCreate: Event){
        apiEvent!.createEvent(event: eventToCreate, completion: { error in
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
    
}
