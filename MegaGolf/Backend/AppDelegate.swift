//
//  AppDelegate.swift
//  MegaGolf
//
//  Created by Haakon Svane on 02/03/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let cParser = MGColorPlistParser()
        GLOBALCOLOR.TEXTMAIN = cParser.entryToUIColor(entryName: "TEXT_MAIN")
        GLOBALCOLOR.TEXTRED = cParser.entryToUIColor(entryName: "TEXT_RED")
        GLOBALCOLOR.TEXTSHADOW = cParser.entryToUIColor(entryName: "TEXT_SHADOW")
        GLOBALCOLOR.GRAVITYFIELD = cParser.entryToUIColor(entryName: "GRAVITY_FIELD")
        GLOBALCOLOR.GRAVITYFIELDBH = cParser.entryToUIColor(entryName: "GRAVITY_FIELD_BH")
        GLOBALCOLOR.SKY = cParser.entryToUIColor(entryName: "SKY")
        GLOBALCOLOR.SLIDERON = cParser.entryToUIColor(entryName: "SLIDER_ON")
        GLOBALCOLOR.SLIDEROFF = cParser.entryToUIColor(entryName: "SLIDER_OFF")
        GLOBALCOLOR.ORBITLINE = cParser.entryToUIColor(entryName: "ORBIT_LINE")
        GLOBALCOLOR.GAMEBOUNDSLINE = cParser.entryToUIColor(entryName: "GAME_BOUNDS_LINE")
        GLOBALCOLOR.BALLAIMREADY = cParser.entryToUIColor(entryName: "BALL_AIM_READY")

        let dParser = MGDefaultPropertiesParser()
        DEFAULTPROPERTIES.FONT = dParser.data["FONT_DEFAULT"] as? String
        DEFAULTPROPERTIES.SETTINGSOPTIONS = dParser.data["SETTINGS_MENU_OPTIONS"] as? [String]
        DEFAULTPROPERTIES.DEFAULTPLAYERNAME = dParser.data["DEFAULT_PLAYER_NAME"] as? String
        
        let defaults = UserDefaults.standard
        let hasLaunchedBefore = defaults.bool(forKey: USERDEFAULTSTRING.LAUNCHEDBEFORE)
        if hasLaunchedBefore {
            
        }else{
            defaults.setValue(true, forKey: USERDEFAULTSTRING.LAUNCHEDBEFORE)
            defaults.setValue(0.5, forKey: USERDEFAULTSTRING.SFXVOLUME)
            defaults.setValue(0.5, forKey: USERDEFAULTSTRING.MUSICVOLUME)
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


}

