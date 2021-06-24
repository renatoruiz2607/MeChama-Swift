//
//  AppDelegate.swift
//  MeChama-Swift
//
//  Created by Roberto Ruiz Cai on 22/06/21.
//  Copyright © 2021 Renato Ruiz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let viewController = HomeViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.backgroundColor = UIColor.white
        window.makeKeyAndVisible()
        return true
    }

}

