//
//  Element.swift
//  ColorSwitch
//
//  Created by Anonymer Eintrag on 13.06.18.
//  Copyright © 2018 hs-rm.de. All rights reserved.
//

import Foundation
import SpriteKit

protocol Element {
    func create(location: CGPoint, ballLocation: CGPoint, initialSet: Bool) -> SKNode
    func doAnimation() -> SKShapeNode
    func create() -> SKShapeNode
    func create(location: CGPoint) -> SKNode
    func isActive() -> Bool
    func getBool() -> Bool
}
