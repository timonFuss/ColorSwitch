//
//  Element.swift
//  ColorSwitch
//
//  Created by Anonymer Eintrag on 13.06.18.
//  Copyright © 2018 hs-rm.de. All rights reserved.
//

import Foundation
import SpriteKit

/// A Protocol to provide the functions that has to be implemented
protocol Element {
    func create(location: CGPoint, ballLocation: CGPoint) -> SKNode
    func doAnimation() -> SKShapeNode
    func create() -> SKShapeNode
    func create(location: CGPoint) -> SKNode
    func isActive() -> Bool
    func isFirstCreation() -> Bool
    func setObjectIsInactive()
    func getActiveState() -> Bool
}
