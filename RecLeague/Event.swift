//
//  Event.swift
//  RecLeague
//
//  Created by Emmett Kotlikoff on 12/20/15.
//  Copyright © 2015 Emmett Kotlikoff. All rights reserved.
//

import Foundation

struct Event {
    
    enum SkillLevel : Int {
        case Beginners = 0, AllWelcome = 1, Competitive = 2
    }
    
    var name : String
    var address : String
    var date : NSDate
    var skill : SkillLevel
    var desiredAttendees : Int
    var exact : Bool
    var maximumAttendees : Int?
    var currentAttendees : Int
    
    init(name : String, address : String, date : NSDate, skill : SkillLevel, desired : Int, exact : Bool, maximum : Int?, current : Int) {
        self.name = name
        self.address = address
        self.date = date
        self.skill = skill
        self.desiredAttendees = desired
        self.exact = exact
        self.maximumAttendees = maximum
        self.currentAttendees = current
    }
}