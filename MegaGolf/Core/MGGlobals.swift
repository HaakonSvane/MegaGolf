//
//  MGGlobals.swift
//  MegaGolf
//
//  Created by Haakon Svane on 15/03/2021.
//

import SpriteKit


enum GLOBALCOLOR{
    static let DEFAULT : UIColor = UIColor(hex: 0xCC397B, a: 0xFF)
    static var TEXTMAIN : UIColor?
    static var TEXTRED : UIColor?
    static var TEXTSHADOW : UIColor?
    static var GRAVITYFIELD : UIColor?
    static var SKY : UIColor?
    static var SLIDERON : UIColor?
    static var SLIDEROFF : UIColor?
    static var ORBITLINE : UIColor?
    static var GAMEBOUNDSLINE: UIColor?
    static var BALLAIMREADY : UIColor?
    static var GRAVITYFIELDBH : UIColor?
}

enum DEFAULTPROPERTIES {
    static var FONT : String?
    static var SETTINGSOPTIONS : [String]?
    static var DEFAULTPLAYERNAME : String?
}

enum USERDEFAULTSTRING {
    static let LAUNCHEDBEFORE : String = "hasLaunchedBefore"
    static let SFXVOLUME : String = "sfxVolume"
    static let MUSICVOLUME : String = "musicVolume"
}
