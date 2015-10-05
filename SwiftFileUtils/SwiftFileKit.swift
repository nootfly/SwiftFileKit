//
//  FileUtils.swift
//  SwiftFileUtils
//
//  Created by Noot on 4/10/2015.
//  Copyright © 2015 NF. All rights reserved.
//

import Foundation


struct FileInfo {
    var name:String
    var size:UInt64
    var line:Int
}

class SwiftFileUtils {
    init(){
        print("Class has been initialised")
    }
    
    func doSomething()  {
        print("Yeah, it works")
    }
    
    class func isFile(filePath:String) -> Bool? {
       return NSFileManager.defaultManager().isFile(filePath)
    }
    
    class func createIOSDocumentFolder(folderName: String) -> Bool {
        return NSFileManager.defaultManager().createIOSDocumentFolder(folderName)
    }
    
    class func createDir(dir:String) -> String? {
       return NSFileManager.defaultManager().createDir(dir)
    }
    
    
    
    class func sortFilesInDirBySize(dir: String, filter:(String -> Bool)) -> [FileInfo]? {
        
        let fileManager = NSFileManager.defaultManager()
        let fileInfoArray = fileManager.allFilesInDirectory(dir, filter: filter)
        return fileInfoArray?.sort {$0.size > $1.size }
  
    }

    class func sortFilesInDirByNumberOfLines(dir: String, filter:(String -> Bool)) -> [FileInfo]? {
        let fileManager = NSFileManager.defaultManager()
        let fileInfoArray = fileManager.allFilesInDirectory(dir, filter: filter)
        return fileInfoArray?.sort {$0.line > $1.line }
    }

   
    
}


    