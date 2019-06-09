//
//  SceneAssembly.swift
//  PareshMasaniCV
//
//  Created by Paresh Masani on 09/06/2019.
//  Copyright © 2019 paresh. All rights reserved.
//

import Foundation
import UIKit

/// Assembles app scenes (by creating view models and view controllers)
struct SceneAssembly {
    
    // The app currently has only one scene. But in future, more enum cases can be added.
    enum Scene {
        case cv
    }
    
    static func assemblyScene(_ scene: Scene) -> UIViewController {
        switch scene {
        case .cv:
            let viewController = UIStoryboard.storyboard(.cv).instantiateViewController() as CVViewController
            viewController.viewModel = CVViewModel()
            return viewController
        }
    }
}
