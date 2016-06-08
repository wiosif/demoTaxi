//
//  VenuesResponse.swift
//  demoTaxiBeat
//
//  Created by Angel Papamichail on 05/06/16.
//  Copyright © 2016 Angel Papamichail. All rights reserved.
//


import Foundation

class VenuesResponse: NSObject {
    private(set) var Venues: VenuesArrayResponse?
    
    //MARK: Initialisation Methods
    ////////////////////////////////////////////////////////////////////////////
    init?(parameters: [String: AnyObject]) {
        guard let userVenues = parameters["response"] as? [String: AnyObject]
            else {
                return nil
        }
        
        self.Venues = VenuesArrayResponse(parameters: userVenues)
        super.init()
    }
}

class VenuesArrayResponse: NSObject {
    private(set) var VenuesArray: [Venue?]
    
    //MARK: Initialisation Methods
    ////////////////////////////////////////////////////////////////////////////
    init?(parameters: [String: AnyObject]) {
        guard let venues = parameters["venues"] as? [[String: AnyObject]]
            else {
                return nil
        }
        
        self.VenuesArray = venues.map{Venue(parameters: $0)}
        super.init()
    }
}

class Venue: NSObject {
    private(set) var venueId: String?
    private(set) var name: String?
    private(set) var image: String?
    private(set) var loc: VenueLocation?
    private(set) var catInfo: [Category?]
    
    //MARK: Initialisation Methods
    ////////////////////////////////////////////////////////////////////////////
    init?(parameters: [String: AnyObject?]) {
        guard let venueId = parameters["id"] as? String,
            let name = parameters["name"] as? String,
            let loc = parameters["location"] as? NSDictionary,
            let categories = parameters["categories"] as? [[String: AnyObject]]
            else {
                return nil
        }
        
        self.venueId = venueId
        self.name = name
        self.loc = VenueLocation(parameters: loc)
        self.catInfo = categories.map{Category(parameters: $0)}
        
        super.init()
    }
    
    //MARK: Public Methods
    ////////////////////////////////////////////////////////////////////////////
    func dictionaryRepresentation() -> Dictionary<String, AnyObject?> {
        var dict: [String : AnyObject] = [:]
        
        dict["id"] = self.venueId
        dict["name"] = self.name
        dict["location"] = self.loc
        dict["categories"] = self.catInfo.first!
        
        return dict
    }
    
    //MARK: Overriden Methods
    ////////////////////////////////////////////////////////////////////////////
    override var description: String {
        return self.dictionaryRepresentation().description
    }
}

class VenueLocation: NSObject {
    private(set) var lon: NSNumber?
    private(set) var lat: NSNumber?
    private(set) var distance: NSNumber?
    private(set) var cc: String?
    private(set) var country: String?
    private(set) var address: String?
    
    //MARK: Initialisation Methods
    ////////////////////////////////////////////////////////////////////////////
    init?(parameters: NSDictionary) {
        let lon = parameters["lng"] as? NSNumber
        let lat = parameters["lat"] as? NSNumber
        let distance = parameters["distance"] as? NSNumber
        let cc = parameters["cc"] as? String
        let country = parameters["country"] as? String
        let address = parameters["address"] as? String
        
        
        self.lon = lon
        self.lat = lat
        self.distance = distance
        self.cc = cc
        self.country = country
        self.address = address
        super.init()
    }
    
    //MARK: Public Methods
    ////////////////////////////////////////////////////////////////////////////
    func dictionaryRepresentation() -> Dictionary<String, AnyObject?> {
        var dict: [String : AnyObject?] = [:]
        dict["lon"] = self.lon
        dict["lat"] = self.lat
        dict["distance"] = self.distance
        dict["cc"] = self.cc
        dict["country"] = self.country
        dict["address"] = self.address
        
        return dict
    }
    
    //MARK: Overriden Methods
    ////////////////////////////////////////////////////////////////////////////
    override var description: String {
        return self.dictionaryRepresentation().description
    }
}

//class vanueCategories: NSObject {
//    private(set) var categoriesArray: [Category?]
//    
//    //MARK: Initialisation Methods
//    ////////////////////////////////////////////////////////////////////////////
//    init?(parameters: [String: AnyObject]) {
//        guard let categories = parameters["categories"] as? [[String: AnyObject]]
//            else {
//                return nil
//        }
//        
//        self.categoriesArray = categories.map{Category(parameters: $0)}
//        super.init()
//    }
//}

class Category: NSObject {
    private(set) var id: String?
    private(set) var name: String?
    private(set) var pluralName: String?
    private(set) var shortName: String?
    
    //MARK: Initialisation Methods
    ////////////////////////////////////////////////////////////////////////////
    init?(parameters: [String: AnyObject?]) {
        guard let id = parameters["id"] as? String,
            let name = parameters["name"] as? String,
            let pluralName = parameters["pluralName"] as? String,
            let shortName = parameters["shortName"] as? String
            else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.pluralName = pluralName
        self.shortName = shortName
        
        super.init()
    }
    
    //MARK: Public Methods
    ////////////////////////////////////////////////////////////////////////////
    func dictionaryRepresentation() -> Dictionary<String, AnyObject?> {
        var dict: [String : AnyObject] = [:]
        
        dict["id"] = self.id
        dict["name"] = self.name
        dict["pluralName"] = self.pluralName
        dict["shortName"] = self.shortName
        
        return dict
    }
    
    //MARK: Overriden Methods
    ////////////////////////////////////////////////////////////////////////////
    override var description: String {
        return self.dictionaryRepresentation().description
    }
}









