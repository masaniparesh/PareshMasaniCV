//
//  FileStorage.swift
//  PareshMasaniCV
//
//  Created by Paresh Masani on 09/06/2019.
//  Copyright © 2019 paresh. All rights reserved.
//

import Foundation

/// Wrapper around `FileManager`, implementing `StorageProtocol`.
struct FileStorage: StorageProtocol {
    private let baseDirectory: FileManager.SearchPathDirectory
    private let directoryName: String
    private let fileManager: FileManager = .default
    
    init(baseDirectory: FileManager.SearchPathDirectory, directoryName: String) {
        self.baseDirectory = baseDirectory
        self.directoryName = directoryName
    }
    
    func getData(forKey key: String) throws -> Data {
        let path = try createFilePath(forKey: key)
        let url = URL(fileURLWithPath: path)
        return try Data(contentsOf: url)
    }
    
    func storeData(_ data: Data, forKey key: String) throws {
        let path = try createFilePath(forKey: key)
        guard fileManager.createFile(atPath: path, contents: data, attributes: nil) else {
            throw StorageError.couldNotCreateFile
        }
    }
    
    func removeData(forKey key: String) throws {
        let path = try createFilePath(forKey: key)
        try fileManager.removeItem(atPath: path)
    }
    
}

private extension FileStorage {
    func createFilePath(forKey key: String) throws -> String {
        guard !key.isEmpty else {
            throw StorageError.emptyKey
        }
        let directoryPath = try createDirectoryPath()
        let filePath = "\(directoryPath)/\(key)"
        guard let encodedFilePath = filePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw StorageError.invalidKey
        }
        return encodedFilePath
    }
    
    func createDirectoryPath() throws -> String {
        let url = try fileManager.url(for: baseDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let path = url.appendingPathComponent(directoryName, isDirectory: true).path
        if !fileManager.fileExists(atPath: path) {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return url.appendingPathComponent(directoryName, isDirectory: true).path
    }
}
