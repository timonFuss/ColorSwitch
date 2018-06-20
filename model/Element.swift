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
    func create(location: CGPoint) -> SKNode
    func doAnimation(oldAngle: CGFloat) -> SKShapeNode
    func create() -> SKShapeNode
    func isActive() -> Bool
}
