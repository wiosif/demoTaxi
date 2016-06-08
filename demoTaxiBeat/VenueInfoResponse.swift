//
//  VenueInfoResponse.swift
//  demoTaxiBeat
//
//  Created by Angel Papamichail on 06/06/16.
//  Copyright © 2016 Angel Papamichail. All rights reserved.
//

import Foundation

class VenueInfo: NSObject {
    private(set) var VenueDataDict: VenuesInfoData
    
    //MARK: Initialisation Methods
    ////////////////////////////////////////////////////////////////////////////
    init?(parameters: [String: AnyObject]) {
        guard let userVenues = parameters["response"] as? [String: AnyObject]
            else {
                return nil
        }
        
        self.VenueDataDict = VenuesInfoData(parameters: userVenues)!
        super.init()
    }
}

class VenuesInfoData: NSObject {
    private(set) var VenuesArray: VenueData
    
    //MARK: Initialisation Methods
    ////////////////////////////////////////////////////////////////////////////
    init?(parameters: [String: AnyObject]) {
        guard let venuesDict = parameters["venue"] as? [String: AnyObject]
            else {
                return nil
        }
        
        self.VenuesArray = VenueData(parameters: venuesDict)!
        super.init()
    }
}

class VenueData: NSObject {
    private(set) var id: String?
    private(set) var rating: Double?
    private(set) var photos: Photos?
    
    //MARK: Initialisation Methods
    ////////////////////////////////////////////////////////////////////////////
    init?(parameters: [String: AnyObject?]) {
        guard let id = parameters["id"] as? String
            else {
                return nil
        }
        let rating = parameters["rating"] as? Double
        let photosDict = parameters["photos"] as? [String: AnyObject]
        
        self.id = id
        self.rating = rating
        self.photos = Photos(parameters: photosDict!)
        
        super.init()
    }
    
    //MARK: Public Methods
    ////////////////////////////////////////////////////////////////////////////
    func dictionaryRepresentation() -> Dictionary<String, AnyObject?> {
        var dict: [String : AnyObject] = [:]
        
        dict["id"] = self.id
        dict["rating"] = self.rating
        
        return dict
    }
    
    //MARK: Overriden Methods
    ////////////////////////////////////////////////////////////////////////////
    override var description: String {
        return self.dictionaryRepresentation().description
    }
}

class Photos: NSObject {
    private(set) var groupsArray: [Group?]
    
    //MARK: Initialisation Methods
    ////////////////////////////////////////////////////////////////////////////
    init?(parameters: [String: AnyObject]) {
        guard let groupDict = parameters["groups"] as? [[String: AnyObject]]
            else {
                return nil
        }
        
        self.groupsArray = groupDict.map{Group(parameters: $0)}
        super.init()
    }
}

class Group: NSObject {
    private(set) var itemsArray: [Items?]
    
    //MARK: Initialisation Methods
    ////////////////////////////////////////////////////////////////////////////
    init?(parameters: [String: AnyObject]) {
        guard let itemDict = parameters["items"] as? [[String: AnyObject]]
            else {
                return nil
        }
        
        self.itemsArray = itemDict.map{Items(parameters: $0)}
        super.init()
    }
}

class Items: NSObject {
    private(set) var prefix: String?
    private(set) var suffix: String?
    
    //MARK: Initialisation Methods
    ////////////////////////////////////////////////////////////////////////////
    init?(parameters: [String: AnyObject]) {
        let prefix = parameters["prefix"] as? String
        let suffix = parameters["suffix"] as? String
        
        self.prefix = prefix
        self.suffix = suffix
        
        super.init()
    }
    
    //MARK: Public Methods
    ////////////////////////////////////////////////////////////////////////////
    func dictionaryRepresentation() -> Dictionary<String, AnyObject?> {
        var dict: [String : AnyObject] = [:]
        
        dict["prefix"] = self.prefix
        dict["suffix"] = self.suffix
        
        return dict
    }
    
    //MARK: Overriden Methods
    ////////////////////////////////////////////////////////////////////////////
    override var description: String {
        return self.dictionaryRepresentation().description
    }
}
