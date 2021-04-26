//
//  UIColorExtension.swift
//  MegaGolf
//
//  Created by Haakon Svane on 09/03/2021.
//

/**
    The contents of this file serve to extend functionallity of the `UIColor` class provided by Apple.
    The class is extended rather than subclassed to ensure compability with all methods and classes provided by Apple.
 */

import SpriteKit

/**
    Convenience structure for use with`UIColor` provided by Apple.
 */
struct RGBA {
    var R : CGFloat = 0
    var G : CGFloat = 0
    var B : CGFloat = 0
    var A : CGFloat = 0
}

extension UIColor{
    
    convenience init(rgba: RGBA){
        self.init(red: rgba.R, green: rgba.G, blue: rgba.B, alpha: rgba.A)
    }
    
    convenience init(hex: UInt32, a: UInt32){
        let red: CGFloat = CGFloat((hex >> 16) & 0xFF)/255.0
        let green: CGFloat = CGFloat((hex >> 8) & 0xFF)/255.0
        let blue: CGFloat = CGFloat(hex & 0xFF)/255.0
        let alpha: CGFloat = CGFloat(a & 0xFF)/255.0
        
        self.init(rgba: RGBA(R: red, G: green, B: blue, A: alpha))
        
    }
    func toRGBA() -> RGBA {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return RGBA(R: red, G: green, B: blue, A: alpha)
    }
    
    func differenceFrom(_ otherColor: UIColor) -> RGBA{
        let c1 = self.toRGBA()
        let c2 = otherColor.toRGBA()
        
        let red = c1.R-c2.R
        let green = c1.G-c2.G
        let blue = c1.B-c2.B
        let alpha = c1.A-c2.A
        return RGBA(R: red, G: green, B: blue, A: alpha)
    }
    
}
