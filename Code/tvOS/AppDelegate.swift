//
//  AppDelegate.swift
//  PuckMan-TV
//
//  Created by Boris Bügling on 12/10/15.
//  Copyright © 2015 Boris Bügling. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = BBUViewController()
        window?.makeKeyAndVisible()
        return true
    }
}
