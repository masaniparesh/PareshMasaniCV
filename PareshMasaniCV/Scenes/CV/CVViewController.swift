//
//  CVViewController.swift
//  PareshMasaniCV
//
//  Created by Paresh Masani on 06/06/2019.
//  Copyright © 2019 paresh. All rights reserved.
//

import Foundation
import UIKit

/// Displays user's CV.
final class CVViewController: UIViewController, StoryboardIdentifiable {
    
    var viewModel: CVViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    private func setupBindings() {
        
    }
}
