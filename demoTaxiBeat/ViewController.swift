//
//  ViewController.swift
//  demoTaxiBeat
//
//  Created by Angel Papamichail on 05/06/16.
//  Copyright © 2016 Angel Papamichail. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Nuke
import Contacts
import AudioToolbox

class ViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var currentAddressLabel: UILabel!
    @IBOutlet var currentLocationView: UIView!
    
    @IBOutlet var currentLocationLabel: UILabel!
    @IBOutlet var currentLocationImage: UIImageView!
    
    @IBOutlet var topBarView: UIView!
    @IBOutlet var closeButton: UIButton!
    
    @IBOutlet var homeButton: UIButton!
    
    @IBOutlet var storeInfoView: DesignableView!
    
    @IBOutlet var storeImage: UIImageView!
    @IBOutlet var storeTitle: UILabel!
    @IBOutlet var streetLabe: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    
    @IBOutlet var currentLocationButton: UIButton!
    @IBOutlet var embedView: UIView!
    @IBOutlet var addressContainerView: UIView!
    
    var venues: [Venue] = []
    var groups: Group?
    var rating: String = ""
    var userLocation: CLLocation?
    
    let locationManager = CLLocationManager()
    
    //MARK: UIViewLifecycle
    ////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
         view.backgroundColor = UIColor(red: 44.0/255.0, green: 121.0/255.0, blue: 91.0/255.0, alpha: 1.0)
         UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        //As we want to show only the candy shops around the user, 10m accuracy is battery
        //killer.
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.delegate = self;
        
        self.storeInfoView.hidden = true
        self.closeButton.hidden = true
        mapView.delegate = self
    }
    
    /*!
     Reverse geocode for coordinates
     
     - parameter coordinate: set coordinates
     */
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        let ll = "\(coordinate.latitude),\(coordinate.longitude)"
        self.getVenues(ll)
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if (response?.firstResult()) != nil {
                self.addMarkerShops()
                
                UIView.animateWithDuration(0.25) {
                    
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    /*!
     Add markers in mapView after load from network call
     */
    func addMarkerShops() -> Void {
        for shopPlace in self.venues {
            let coordinates = CLLocationCoordinate2DMake(Double((shopPlace.loc?.lat)!), Double((shopPlace.loc?.lon)!))
            
            let marker = GMSMarker(position: coordinates)
            marker.title = shopPlace.name
            marker.userData = shopPlace.venueId
            marker.snippet = shopPlace.catInfo.first??.name
            marker.icon = UIImage(named: "venueImg")
            marker.map = self.mapView
        }
    }

    /*!
     Show user Current Location
     
     - parameter sender: Any
     */
    @IBAction func showCurrentLocation(sender: AnyObject) {
        mapView.settings.myLocationButton = true
        
        if let coordinates = self.userLocation?.coordinate {
            self.mapView.animateToCameraPosition(GMSCameraPosition.cameraWithTarget(coordinates, zoom: 15))
        }
        
    }
    
    ////////////////////////////////////////
    @IBAction func closeButton(sender: AnyObject) {
        self.storeInfoView.hidden = true
        self.closeButton.hidden = true
    }
    
    func showUserAddress(placemark: CLPlacemark) {
        var street: String = ""
        if let streetName = placemark.thoroughfare {
            street = streetName
        }
        
        if let streetNumber = placemark.subThoroughfare {
            street = street + " " + streetNumber
        }
        
        let postalAddress = CNMutablePostalAddress()
        
        postalAddress.street = street
        if let cityString = placemark.locality {
            postalAddress.city = cityString
        }
        if let stateString = placemark.administrativeArea {
            postalAddress.state = stateString
        }
        if let postalCodeString = placemark.postalCode {
            postalAddress.postalCode = postalCodeString
        }
        if let countryString = placemark.country {
            postalAddress.country = countryString
        }
        if let ISOCountryCodeString = placemark.ISOcountryCode {
            postalAddress.ISOCountryCode = ISOCountryCodeString
        }
        let formattedAddress: String = String(CNPostalAddressFormatter.stringFromPostalAddress(postalAddress, style: .MailingAddress).characters.map({
            $0 == "\n" ? " " : $0
        }))
        
        self.currentAddressLabel.text = formattedAddress
        self.addressContainerView.shakeAndVibrate()
    }
    
    //MARK: MemoryManagement
    ////////////////////////////////////////////////////////////////////////////
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    /*!
     Check of changeAuthorizatonStatus
     
     - parameter manager: CLLocationManager
     - parameter status:  CLAuthorizationStatus
     */
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

            switch status{
            case .NotDetermined:
                manager.requestWhenInUseAuthorization()
                break
            case .AuthorizedAlways, .AuthorizedWhenInUse :
                manager.startUpdatingLocation()
                break
            case .Restricted, .Denied:
                // show location alert
                break
            }
        
        if status == .AuthorizedWhenInUse {
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        } else {
            // show error to user
        }
    }
    
    /*!
     Update location
     
     - parameter manager:   CLLocationManager
     - parameter locations: [CLLocation]
     */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last where location.horizontalAccuracy <= manager.desiredAccuracy
            else {
            return
        }
        
        self.userLocation = location
        
        mapView.camera = GMSCameraPosition(target: location.coordinate,
                                           zoom: 15,
                                           bearing: 0,
                                           viewingAngle: 0)
        
        let currentLoc = GMSMarker(position: location.coordinate)
        currentLoc.icon = UIImage(named: "currentLoc")
        currentLoc.map = self.mapView
        currentLoc.tappable = false
        
        CLGeocoder().reverseGeocodeLocation(location,
                                            completionHandler: {(placemarks, error) -> Void in
                                                if (error != nil) {
                                                    // Couldn't reverse geocode user's location
                                                    // Show an alert?
                                                } else {
                                                    if let placemark = placemarks?.last {
                                                        self.showUserAddress(placemark)
                                                    }
                                                }
        })
        
        let latlong = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        self.getVenues(latlong)
        locationManager.stopUpdatingLocation()
    }
    
    /*!
     Check position map
     
     - parameter mapView:  GMSMapView
     - parameter position: GMSCameraPosition
     */
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    
    /*!
     Select Marker and show view on the top of viewController
     
     - parameter mapView: GMSMapView
     - parameter marker:  GMSMarker
     
     - returns: Boolean
     */
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        self.deselectMarker()
        
        marker.icon = UIImage(named: "venueSelectImg")
        mapView.selectedMarker = marker
        self.storeInfoView.hidden = true
        self.closeButton.hidden = true
        return true
    }
    
    ////////////////////////////////////////////////////////////////////////////
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        var markerID: String?
        
        for dataMarker in self.venues {
            if marker.title == dataMarker.name {
                markerID = dataMarker.venueId
                self.getVenuesForSpecificPlace(markerID!)
                self.storeInfoView.hidden = false
                self.closeButton.hidden = false
                self.storeTitle.text = dataMarker.name
                self.streetLabe.text = dataMarker.loc?.address
                self.categoryLabel.text = dataMarker.catInfo.first??.name
            }
        }
        
        mapView.selectedMarker = nil;
    }
    
    /*!
     Deselect marker and set nil data in top View
     */
    func deselectMarker() -> Void {
        self.storeImage.image = nil
        self.storeTitle.text = nil
        self.streetLabe.text = nil
        self.categoryLabel.text = nil
        
    }
}

//MARK: Network call
extension ViewController {
    
    /*!
     Network call getValues for stores every time where change lotion
     
     - parameter ll: currentLocation
     */
    func getVenues(ll: String) -> Void {
        // Add URL parameters
        let urlParams = [
            "ll":"\(ll ?? "")",
            "client_id":"HD31OVGQYXDP4WFP5OM15SL3PR1YCTECNU22Q0FUP2HLQS35",
            "client_secret":"MUYLDP5SFPPT5KL02OBV0RPPFUFVMNILEZRGQRJMV5XD3X3K",
            "v":"20160605",
            "categoryId":"4bf58dd8d48988d117951735",
            "radius":"1000",
            ]
        
        HTTPClient.sharedInstance.placesRequest([:], parameters: urlParams) { (result) in
            if result != nil {
                self.venues = (result?.Venues?.VenuesArray.map({ (venue) -> Venue in
                    //Create Annotation from lat and lon Swift
                    return venue!
                }))!
                if self.venues.first != nil {
                    self.venues.append(self.venues.first!)
                }
            } else {
                
            }
        }
    }
    
    /*!
     Get values from specific place (get image, rating)
     
     - parameter venueId: <#venueId description#>
     */
    func getVenuesForSpecificPlace(venueId: String) -> Void {
        // Add URL parameters
        let urlParams = [
            "client_id":"HD31OVGQYXDP4WFP5OM15SL3PR1YCTECNU22Q0FUP2HLQS35",
            "client_secret":"MUYLDP5SFPPT5KL02OBV0RPPFUFVMNILEZRGQRJMV5XD3X3K",
            "v":"20160605"
            ]
        
        HTTPClient.sharedInstance.venueInfoRequest([:], parameters: urlParams, venueId: venueId) { (result) in
            if result != nil {
                
                guard let groupData = result?.VenueDataDict.VenuesArray.photos?.groupsArray.first else {
                    return
                }
                
                self.groups = ((groupData)!)
                let urlImage = "\(self.groups?.itemsArray.first??.prefix ?? "")150x150\(self.groups?.itemsArray.first??.suffix ?? "")"
                self.storeImage.nk_setImageWith(NSURL(string: urlImage)!)
                
                
                if (result?.VenueDataDict.VenuesArray.rating != nil){
                    self.rating = String(format: "%.1f", (result?.VenueDataDict.VenuesArray.rating)!)
                    self.ratingLabel.text = self.rating
                } else {
                    if (self.rating == "" || self.rating == "nil") {
                        self.ratingLabel.text = "N/A"
                    }
                }
            }
        }
    }
}

extension UIView {
    public func shakeAndVibrate() {
        let shake: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shake.delegate = self
        shake.duration = 0.3
        shake.values = [NSNumber(integer: 0),
                        NSNumber(integer: 10),
                        NSNumber(integer: -8),
                        NSNumber(integer: 8),
                        NSNumber(integer: -5),
                        NSNumber(integer: 5),
                        NSNumber(integer: 0)]
        shake.keyTimes = [NSNumber(double: 0),
                          NSNumber(double: 0.225),
                          NSNumber(double: 0.425),
                          NSNumber(double: 0.6),
                          NSNumber(double: 0.75),
                          NSNumber(double: 0.875),
                          NSNumber(double: 1)]
        shake.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
        layer.addAnimation(shake, forKey: "shake")
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}
