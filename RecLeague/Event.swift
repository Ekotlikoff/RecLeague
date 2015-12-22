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
    var skill : SkillLevel
    var desiredAttendees : Int
    var minimumAttendees : Int
    var currentAttendees : Int
    // TODO time/location
    
    init(name : String, skill : SkillLevel, desired : Int, minimum : Int, current : Int) {
        self.name = name
        self.skill = skill
        self.desiredAttendees = desired
        self.minimumAttendees = minimum
        self.currentAttendees = current
    }
}