//
//  StorageProtocol.swift
//  PareshMasaniCV
//
//  Created by Paresh Masani on 09/06/2019.
//  Copyright © 2019 paresh. All rights reserved.
//

import Foundation

/// Describes possible error that can occur when working with storage.
enum StorageError: Error {
    case emptyKey
    case invalidKey
    case couldNotCreateFile
}

/// Interface for storing, accessing and deleting data
/// Methods can throw `StorageError` errors or errors from `FileManager`.
protocol StorageProtocol {
    func getData(forKey key: String) throws -> Data
    func storeData(_ data: Data, forKey key: String) throws
    func removeData(forKey key: String) throws
}
