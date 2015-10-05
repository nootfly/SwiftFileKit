//
//  FileExtensions.swift
//  SwiftFileKit
//
//  Created by Noot on 4/10/2015.
//  Copyright © 2015 NF. All rights reserved.
//

import Foundation

extension NSFileManager {
    func createIOSDocumentFolder(folderName: String) -> Bool {
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let dataPath = dir.stringByAppendingPathComponent(folderName)
            if (!self.fileExistsAtPath(dataPath)) {
                do {
                    try NSFileManager.defaultManager().createDirectoryAtPath(dataPath, withIntermediateDirectories: false, attributes: nil)
                    return true
                } catch {
                    print("create \(folderName) dir failed")
                }
            }
        }
        return false
    }
    
    func createDir(dir:String) -> String? {
        if (!self.fileExistsAtPath(dir)) {
            do {
                try self.createDirectoryAtPath(dir, withIntermediateDirectories: false, attributes: nil)
                return dir
            } catch {
                print("create \(dir) dir failed")
            }
        }
        return nil
    }
    
    func deleteFileOrDir(filePath: String) {
        do {
            try self.removeItemAtPath(filePath)
        } catch {
            print("del \(filePath) failed")
        }
        
    }
    
    func isFile(filePath:String) -> Bool? {
        var isDir : ObjCBool = false
        if self.fileExistsAtPath(filePath, isDirectory:&isDir) {
            if isDir {
                return false
            } else {
                return true
            }
        } else {
            return nil
        }
    }
    
    func allFilesInDirectory( dir: String, filter:(String -> Bool)) -> [FileInfo]? {
        let enumerator:NSDirectoryEnumerator? = self.enumeratorAtPath(dir)
        guard enumerator != nil else { return nil }
        var fileArray = [FileInfo]()
        while let element = enumerator?.nextObject() as? String {
            let fileElement = (dir as NSString).stringByAppendingPathComponent(element) as NSString
            if let flag = isFile(fileElement as String) {
                if flag {
                    if filter(fileElement as String) {
                        let fileInfo = FileInfo(name:fileElement.lastPathComponent, size:self.fileSize(fileElement as String), line: numberOfLinesInFile(fileElement as String))
                        fileArray.append(fileInfo)
                    }
                } else if let newArray = allFilesInDirectory(element, filter: filter) {
                  fileArray += newArray
                  
                }
                
            } else {
                  print("invalid element=\(element)")
            }
        }
        
        return fileArray
    }
    
    func numberOfLinesInFile(filePath:String) -> Int {
        do {
            let fileContents = try NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
            let allLinedStrings = fileContents.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
            return allLinedStrings.count
        } catch {
             print("Error: \(error)")
        }
        return Int(0)
    }
    
    func fileSize(filePath: String) -> UInt64 {
        var fileSize : UInt64 = 0
        
        do {
            let attr : NSDictionary? = try NSFileManager.defaultManager().attributesOfItemAtPath(filePath)
            
            if let _attr = attr {
                fileSize = _attr.fileSize();
            }
        } catch {
            print("Error: \(error)")
        }
        return fileSize
    }
    
}


