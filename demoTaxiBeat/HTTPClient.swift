//
//  HTTPClient.swift
//  demoTaxiBeat
//
//  Created by Angel Papamichail on 05/06/16.
//  Copyright © 2016 Angel Papamichail. All rights reserved.
//

import UIKit
import Alamofire

private let baseURLString = "https://api.foursquare.com/v2"

public enum HTTPRouter {
    
    case Root
    case Venues
    case VenueInfo
    
    public var URLString: String {
        return {
            switch self {
            case .Root:
                return baseURLString
            case .Venues:
                return baseURLString + "/venues/search"
            case .VenueInfo:
                return baseURLString + "/venues/"
            }
        }()
    }
}

class HTTPClient {
    static let sharedInstance = HTTPClient()
}

extension HTTPClient {
    
    //Get venues call
    ////////////////////////////////////////////////////////////////////////////
    func placesRequest(headersParams: [String: String], parameters:[String: String], completion: (result: VenuesResponse?) -> Void) {
        
        Alamofire.request(.GET, HTTPRouter.Venues.URLString, headers: headersParams, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .Success:
                    if let value = response.result.value as? [String: AnyObject] {
                        let venuesData: VenuesResponse? = VenuesResponse(parameters: value)
                        completion(result: venuesData)
                    }
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    completion(result: nil)
                }
        }
    }
    
    //Get venues call
    ////////////////////////////////////////////////////////////////////////////
    func venueInfoRequest(headersParams: [String: String], parameters:[String: String], venueId: String, completion: (result: VenueInfo?) -> Void) {
        
        Alamofire.request(.GET, HTTPRouter.VenueInfo.URLString + venueId, headers: headersParams, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .Success:
                    if let value = response.result.value as? [String: AnyObject] {
                        let venuesData: VenueInfo? = VenueInfo(parameters: value)
                        completion(result: venuesData)
                    }
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    completion(result: nil)
                }
        }
    }
}
