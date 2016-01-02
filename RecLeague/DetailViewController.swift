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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var location: UIButton!
    @IBOutlet weak var desiredLabel: UILabel!
    @IBOutlet weak var maximumLabel: UILabel!
    @IBOutlet weak var maximumTextLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var skillLabel: UILabel!
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
                currentLabel.text = String(newAttending)
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
                currentLabel.text = String(newAttending)
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
            if let dateLabel = self.dateLabel {
                dateLabel.text = String(event.valueForKey("date")!)
            }
            if let desiredLabel = self.desiredLabel {
                desiredLabel.text = String(event.valueForKey("desiredAttendees")!)
            }
            if let maximumLabel = self.maximumLabel {
                if let maximum = event.valueForKey("maximumAttendees") {
                    maximumLabel.text = String(maximum)
                } else {
                    maximumLabel.removeFromSuperview()
                    maximumTextLabel.removeFromSuperview()
                }
            }
            if let currentLabel = self.currentLabel {
                currentLabel.text = String(event.valueForKey("currentAttendees")!)
            }
            if let skillLabel = self.skillLabel {
                skillLabel.text = skillToString(Int(String(event.valueForKey("skill")!))!)
            }
            if let attending = self.attending {
                let IDs = event.valueForKey("attendingIDs")!
                let bool = IDs.containsObject(DeviceUID.uid())
                attending.setOn(bool, animated: false)
            }
        }
    }
    
    
    private func skillToString(skill : Int) -> String {
        switch (skill) {
        case 0:
            return "Beginners"
        case 1:
            return "All welcome"
        case 2:
            return "Competitive"
        default:
            return ""
        }
    }
    
    @IBAction func addressTapped(sender: AnyObject) {
        print((location.titleLabel?.text!)!)
        if let targetURL = NSURL(string: "http://maps.apple.com/?q=" + (location.titleLabel?.text!)!) {
            UIApplication.sharedApplication().openURL(targetURL)
        } else if let targetURL = NSURL(string: "http://maps.apple.com/?q=" + ((event?.valueForKey("coordinates"))! as! String)){
            UIApplication.sharedApplication().openURL(targetURL)
        }
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

