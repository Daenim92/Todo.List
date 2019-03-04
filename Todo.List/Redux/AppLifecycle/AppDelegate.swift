//
//  AppDelegate.swift
//  Todo.List
//
//  Created by Dmytro Baida on 2/26/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import UIKit
import ReSwiftRouter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        try! dependency.bootstrap()
        
        dependency.appStateStore.dispatch(SetRouteAction([R.storyboard.main.access.identifier]))
        return true
    }
}

