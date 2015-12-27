//
//  DetailViewController.swift
//  RecLeague
//
//  Created by Emmett Kotlikoff on 12/20/15.
//  Copyright © 2015 Emmett Kotlikoff. All rights reserved.
//

import UIKit
import GoogleMaps

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var location: UIButton!
    @IBOutlet weak var desired: UILabel!
    @IBOutlet weak var minimum: UILabel!
    @IBOutlet weak var current: UILabel!
    @IBOutlet weak var attending: UISwitch!
    
    var tapGestureRecognizer: UITapGestureRecognizer?
    
    var event: PFObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    @IBAction func attendingChanged(sender: AnyObject) {
        if (attending.on) {
            if let event = self.event {
                // increment attending
                let newAttending = Int(event.valueForKey("currentAttendees") as! NSNumber) + 1
                event.setObject(newAttending, forKey: "currentAttendees")
                current.text = String(newAttending)
                // add uid to array
                event.addObject(DeviceUID.uid(), forKey: "attendingIDs")
                event.saveInBackground()
                attending.enabled = false
            }
        } else {
            if let event = self.event {
                // decrement attending
                let newAttending = Int(event.valueForKey("currentAttendees") as! NSNumber) - 1
                event.setObject(newAttending, forKey: "currentAttendees")
                current.text = String(newAttending)
                // remove uid to array
                let newArr = event.valueForKey("attendingIDs")
                newArr?.removeObject(DeviceUID.uid())
                event.setObject(newArr!, forKey: "attendingIDs")
                event.saveInBackground()
                attending.enabled = false
            }
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let event = self.event {
            if let label = self.detailDescriptionLabel {
                label.text = String(event.valueForKey("name")!)
            }
            if let location = self.location {             location.setTitle(String(event.valueForKey("address")!), forState: UIControlState.Normal)
                
            }
            if let date = self.date {
                date.text = String(event.valueForKey("date")!)
            }
            if let desired = self.desired {
                desired.text = String(event.valueForKey("desiredAttendees")!)
            }
            if let minimum = self.minimum {
                minimum.text = String(event.valueForKey("minimumAttendees")!)
            }
            if let current = self.current {
                current.text = String(event.valueForKey("currentAttendees")!)
            }
            if let attending = self.attending {
                let IDs = event.valueForKey("attendingIDs")!
                let bool = IDs.containsObject(DeviceUID.uid())
                attending.setOn(bool, animated: false)
            }
        }
    }
    
    @IBAction func addressTapped(sender: AnyObject) {
        let targetURL = NSURL(string: "http://maps.apple.com/?q=" + (location.titleLabel?.text!)!)!
        UIApplication.sharedApplication().openURL(targetURL)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

