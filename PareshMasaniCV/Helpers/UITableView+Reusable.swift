//
//  UITableView+Reusable.swift
//  PareshMasaniCV
//
//  Created by Paresh Masani on 09/06/2019.
//  Copyright © 2019 paresh. All rights reserved.
//

import UIKit

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(className: T.Type) -> T {
        let name = "\(T.self)"
        guard let cell = self.dequeueReusableCell(withIdentifier: name) as? T else {
            fatalError("Error: dequeueReusableCell: \(NSStringFromClass(T.self)) is not \(T.self)")
        }
        return cell
    }
    
}


