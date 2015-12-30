//
//  AddViewController.swift
//  RecLeague
//
//  Created by Emmett Kotlikoff on 12/20/15.
//  Copyright © 2015 Emmett Kotlikoff. All rights reserved.
//

import UIKit
import Parse
import Bolts
import GoogleMaps

class AddViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    var delegate: MasterViewController?
    var event: Event?
    var placePicker: GMSPlacePicker?
    var latitude: CLLocationDegrees? = nil
    var longitude: CLLocationDegrees? = nil
    let manager = CLLocationManager()
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    var addressCoordinates: String?
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var skillLevel: UISegmentedControl!
    @IBOutlet weak var desired: UITextField!
    @IBOutlet weak var minimum: UITextField!
    @IBOutlet weak var current: UITextField!
    
    @IBAction func saveEvent(sender: UIButton) {
        if let name = name.text,
            address = address.text,
            skill = Event.SkillLevel(rawValue: skillLevel.selectedSegmentIndex),
            desired = Int(desired.text!),
            minimum = Int(minimum.text!),
            current = Int(current.text!) {
                event = Event(name: name, address: address, date: date.date, skill: skill, desired: desired, minimum: minimum, current: current)
                save(event!)
                delegate!.popController()
        }
    }
    
    @IBAction func addPlace(sender: AnyObject) {
        view.endEditing(true)
        var center : CLLocationCoordinate2D
        if let latitude = latitude, longitude = longitude {
            center = CLLocationCoordinate2DMake(latitude, longitude)
        } else {
            center = CLLocationCoordinate2DMake(51.5108396, -0.0922251);
        }
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)

        placePicker = GMSPlacePicker(config: config)
        
        placePicker?.pickPlaceWithCallback({ (place: GMSPlace?, error: NSError?) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                if let text = place.formattedAddress {
                    self.address.text = text.componentsSeparatedByString(", ").joinWithSeparator("\n")
                }
                self.addressCoordinates = place.coordinate.latitude.description + "," + place.coordinate.longitude.description
            }
        })
    }
    
    private func save(event: Event) {
        let obj = PFObject(className: delegate!.className)
        obj.setObject(event.name, forKey: "name")
        obj.setObject(event.address, forKey: "address")
        obj.setObject(self.addressCoordinates!, forKey: "coordinates")
        obj.setObject(addressCoordinates!, forKey: "addressCoordinates")
        obj.setObject(event.date, forKey: "date")
        obj.setObject(event.skill.rawValue, forKey: "skill")
        obj.setObject(event.desiredAttendees, forKey: "desiredAttendees")
        obj.setObject(event.minimumAttendees, forKey: "minimumAttendees")
        obj.setObject(event.currentAttendees, forKey: "currentAttendees")
        let UID : String = DeviceUID.uid()
        obj.addObject(UID, forKey: "attendingIDs")
        obj.saveInBackgroundWithBlock {
            (success, error) in
            if success == true {
                print("Event created with ID: \(obj.objectId)")
            } else {
                print(error)
            }
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            manager.requestWhenInUseAuthorization()
        }
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways, .AuthorizedWhenInUse: break
        case .NotDetermined:
            manager.requestWhenInUseAuthorization()
        case .Restricted, .Denied:
            let alertController = UIAlertController(
                title: "Location Access Disabled",
                message: "For ease of use consider enabling location services.",
                preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        manager.requestLocation()
        name.delegate = self
        address.delegate = self
        desired.delegate = self
        minimum.delegate = self
        current.delegate = self
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done,
            target: view, action: Selector("endEditing:"))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        desired.inputAccessoryView = keyboardToolbar
        minimum.inputAccessoryView = keyboardToolbar
        current.inputAccessoryView = keyboardToolbar
    
        self.navigationController!.setNavigationBarHidden(false, animated:true)
        let myBackButton:UIButton = UIButton(type: UIButtonType.Custom)
        myBackButton.addTarget(self, action: "backPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        myBackButton.setTitle("Back", forState: UIControlState.Normal)
        myBackButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        myBackButton.sizeToFit()
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
    }
    
    func backPressed(sender: AnyObject) {
        if (name.text != "" || address.text != "" || current.text != "") {
            let style = UIAlertControllerStyle.init(rawValue: 0)!
            let alert = UIAlertController.init(title: "Forget to save?", message: "Cancel or go back.", preferredStyle: style)
            let action = UIAlertAction.init(title: "Back", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                self.delegate?.navigationController?.navigationBar.userInteractionEnabled = false
                self.delegate?.popController()
            })
            let cancel = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
            })
            alert.addAction(action)
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            self.delegate?.navigationController?.navigationBar.userInteractionEnabled = false
            self.delegate?.popController()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
