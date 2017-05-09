//
//  FileFunctions.swift
//  Event Swipe
//
//  Created by Erick Sauri on 5/9/17.
//  Copyright © 2017 Erick Sauri. All rights reserved.
//

import Foundation
import UIKit

// MARK: FileManager Extension
extension FileManager {
    static var documentsDirectory: URL {
        return self.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
    }
    
    static var tempDirectory: URL {
        return self.default.temporaryDirectory
    }
    
    static var cachesDirectory: URL {
        return self.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as URL
    }
    
    static func filePathInDocumentsDirectory(fileName: String) -> URL {
        return self.documentsDirectory.appendingPathComponent(fileName)
    }
    
    static func fileExistsInDocumentsDirectory(fileName: String) -> Bool {
        let path = filePathInDocumentsDirectory(fileName: fileName).path
        return self.default.fileExists(atPath: path)
    }
    
    static func deleteFileInDocumentsDirectory(fileName: String) {
        let path = filePathInDocumentsDirectory(fileName: fileName).path
        
        do {
            try self.default.removeItem(atPath: path)
            print("FILE: \(path) was deleted!")
        } catch {
            print("ERROR: \(error) - FOR FILE: \(path)")
        }
    }
    
    static func contentsOfDir(url: URL) -> [String] {
        do {
            if let paths = try self.default.contentsOfDirectory(atPath: url.path) as [String]? {
                return paths
            } else {
                print("None found")
                return [String]() // return empty array of strings
            }
        } catch {
            print("ERROR: \(error)")
            return [String]() // return empty array of strings on error
        }
    }
    
    static func clearDocumentsFolder() {
        let fileManager = self.default
        let docsFolderPath = self.documentsDirectory.path
        
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: docsFolderPath)
            for filePath in filePaths {
                let docToDelete = "\(docsFolderPath)/\(filePath)"
                try fileManager.removeItem(atPath: docToDelete)
            }
            print("Cleared Documents folder")
        } catch {
            print("Could not clear documents folder: \(error)")
        }
    }
}

// MARK: UIImage Extension
extension UIImage {
    func saveImageAsPNG(url: URL) {
        let pngData = UIImagePNGRepresentation(self)
        do {
            try pngData?.write(to: url)
        } catch {
            print("ERROR: saving \(url) - error = \(error)")
        }
    }
}
