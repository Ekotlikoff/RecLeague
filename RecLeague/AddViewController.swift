//
//  AddViewController.swift
//  RecLeague
//
//  Created by Emmett Kotlikoff on 12/20/15.
//  Copyright © 2015 Emmett Kotlikoff. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    var delegate : MasterViewController? = nil
    var event : Event?
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var skillLevel: UISegmentedControl!
    @IBOutlet weak var desired: UITextField!
    @IBOutlet weak var minimum: UITextField!
    @IBOutlet weak var current: UITextField!
    
    @IBAction func saveEvent(sender: UIButton) {
        if let name = name.text,
            skill = Event.SkillLevel(rawValue: skillLevel.selectedSegmentIndex),
            desired = Int(desired.text!),
            minimum = Int(minimum.text!),
            current = Int(current.text!) {
                event = Event(name: name, skill: skill, desired: desired, minimum: minimum, current: current)
                print(event)
                // TODO send event to db
                delegate!.popController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
