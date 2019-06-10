//
//  DataFromJSON.swift
//  PareshMasaniCVTests
//
//  Created by Paresh Masani on 09/06/2019.
//  Copyright © 2019 paresh. All rights reserved.
//

import Foundation

func dataFromJSON(withName name: String) -> Data? {
    guard let fileURL = Bundle(for: CVModelDecodingTests.self).url(forResource: name, withExtension: "json") else {
        return nil
    }
    return try? Data(contentsOf: fileURL)
}
