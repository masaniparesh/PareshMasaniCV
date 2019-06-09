//
//  AppDelegate.swift
//  PareshMasaniCV
//
//  Created by Paresh Masani on 06/06/2019.
//  Copyright © 2019 paresh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let window = UIWindow()
    
    private var router: Router?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigationController = UINavigationController()
        let router = Router(navigationController: navigationController)
        router.showCV()
        self.router = router
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        return true
    }

}
