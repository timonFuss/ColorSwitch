//
//  ElemetFactory.swift
//  ColorSwitch
//
//  Created by Anonymer Eintrag on 13.06.18.
//  Copyright © 2018 hs-rm.de. All rights reserved.
//

import Foundation
import SpriteKit

class ElementFactory {
    
    private static var instance: ElementFactory?
    
    private init() {
    }
    
    public static func getInstance() -> ElementFactory {
        if(instance == nil){
            instance = ElementFactory()
        }
        return instance!
    }
    
    public func getElement(sort: Sort, center: CGPoint) -> Element {
        if (sort == Sort.PLAYER) {
            return PlayerFigure()
        }else if (sort == Sort.SEPERATEDCIRCLE){
            //TODO VARIABLEN AUSLAGERN
            return SeperatedCircle(amountSegments: 4, center: center, radius: CGFloat(450), gapSize: CGFloat(0.008), lineWidth: CGFloat(100))
        }
        /*else if (sort == Sort.SQUARE){
            return Square()
        }*/
        //TODO ändern
        return PlayerFigure()
    }
    
}
