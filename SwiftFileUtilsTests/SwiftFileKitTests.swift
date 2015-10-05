//
//  SwiftFileUtilsTests.swift
//  SwiftFileUtilsTests
//
//  Created by Noot on 4/10/2015.
//  Copyright © 2015 NF. All rights reserved.
//

import XCTest
@testable import SwiftFileKit

class SwiftFileKitTests: XCTestCase {
    let fileManager = NSFileManager.defaultManager()
    var testDir:String?
    var testFile:String?
    
    override func setUp() {
        super.setUp()
        let currentPath = fileManager.currentDirectoryPath
        testDir = (currentPath as NSString).stringByAppendingPathExtension("tempDir")
        if let dir = testDir {
            do {
                try fileManager.createDirectoryAtPath(dir, withIntermediateDirectories: false, attributes: nil)
            } catch {
                print("create \(dir) dir failed")
            }
        }
        testFile = (currentPath as NSString).stringByAppendingPathExtension("temp.file")
        if let testFile = testFile {
          fileManager.createFileAtPath(testFile, contents: NSData(), attributes: nil)
        }
    }
    
    override func tearDown() {
        if let dir = testDir {
            removeItem(dir)
        }
        if let testFile = testFile {
            removeItem(testFile)
        }
        
        super.tearDown()
    }
    
    func removeItem(filePath:String) {
        do {
            try fileManager.removeItemAtPath(filePath)
        } catch {
            print("del \(filePath) failed")
        }
        
    }
    
    func testIsFile() {
        if let dir = testDir {
            if let isFile = SwiftFileUtils.isFile(dir) {
                XCTAssertFalse(isFile)
            }
        }
        if let testFile = testFile {
            if let isFile = SwiftFileUtils.isFile(testFile) {
                XCTAssertTrue(isFile)
            }
        }
    }
    
    func testSortFilesInDirByNumberOfLines() {
        let dir = "/Users/Noot/Developer/iOS/SendLocation"
        let flag = "SwiftFileKit.mom".hasSuffix(".m")
        print("flag = \(flag)")
        let fileArray = SwiftFileUtils.sortFilesInDirBySize(dir) { fileName  -> Bool in
            return (fileName.hasSuffix(".m") || fileName.hasSuffix(".swift")) && !fileName.containsString("Pods")
        }
        XCTAssertTrue(fileArray?.count > 0)
        if fileArray?.count > 0 {
            print(fileArray?[0])
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
