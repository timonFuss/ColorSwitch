//
//  PlayerScoreModel.swift
//  ColorSwitch
//
//  Created by Anonymer Eintrag on 09.07.18.
//  Copyright © 2018 hs-rm.de. All rights reserved.
//

import Foundation
import CoreData

class PlayerScoreModel: NSManagedObject{
    static let entityName = "PlayerScore"
    
    @NSManaged var name : String?
    @NSManaged var score : Int
}
