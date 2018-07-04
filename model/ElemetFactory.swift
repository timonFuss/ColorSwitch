//
//  ElemetFactory.swift
//  ColorSwitch
//
//  Created by Anonymer Eintrag on 13.06.18.
//  Copyright © 2018 hs-rm.de. All rights reserved.
//

import Foundation
import SpriteKit

/// A Factory to create different Elements
class ElementFactory {
    
    private static var instance: ElementFactory?
    
    
    /// ElementFactory as Singleton
    ///
    /// - Returns: the only instance of the Factory
    public static func getInstance() -> ElementFactory {
        if(instance == nil){
            instance = ElementFactory()
        }
        return instance!
    }
    
    /// Factory Function to create an Element
    ///
    /// - Parameters:
    ///   - sort: Enum that specifies the object
    ///   - center: the Position where the Element should be created
    /// - Returns: the Element that was created
    public func getElement(sort: Sort, center: CGPoint, positionBottom: Bool) -> Element {
        if (sort == Sort.PLAYER) {
            return PlayerFigure()
        }else if (sort == Sort.SEPERATEDCIRCLE){

            return SeperatedCircle(amountSegments: 4, center: center, radius: CGFloat(450))
        }else if (sort == Sort.WALL){
            return Wall(screenCenter: center, positionBottom: positionBottom)
        }
        /*else if (sort == Sort.SQUARE){
            return Square()
        }*/
        //TODO ändern
        return PlayerFigure()
    }
    
}
