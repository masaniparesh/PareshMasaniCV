//
//  UIApplication+Utils.swift
//  PareshMasaniCV
//
//  Created by Paresh Masani on 09/06/2019.
//  Copyright © 2019 paresh. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    func callPhone(_ phone: String) {
        let phone = phone.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
        if let url = URL(string: "tel://\(phone)") {
            open(url, options: [:], completionHandler: nil)
        }
    }
    
    func sendEmail(to email: String) {
        if let url = URL(string: "mailto:\(email)") {
            open(url, options: [:], completionHandler: nil)
        }
    }
    
}

