//
//  Router.swift
//  PareshMasaniCV
//
//  Created by Paresh Masani on 09/06/2019.
//  Copyright © 2019 paresh. All rights reserved.
//

import Foundation
import UIKit

// N.B
// This app has only one screen and doesn't need a router or even a navigation controller.
// But I still created it to show how the architecture would look if there would be more screens.
struct Router {
    let navigationController: UINavigationController
    
    func showCV() {
        let viewController = SceneAssembly.assemblyScene(.cv)
        navigationController.pushViewController(viewController, animated: false)
    }
}
