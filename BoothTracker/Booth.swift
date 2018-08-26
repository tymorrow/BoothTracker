//
//  Booth.swift
//  BoothTracker
//
//  Created by Ty Morrow on 8/25/18.
//  Copyright © 2018 Ty Morrow. All rights reserved.
//

import UIKit
import os.log

class Booth: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var location: String
    var lastUpdated: Date
    var needsService: Bool = false
    var isDown: Bool = false
    var needsGlassCleaner: Bool = false
    var needsRag: Bool = false
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("booths")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let location = "location"
        static let lastUpdated = "lastUpdated"
        static let needsService = "needsService"
        static let isDown = "isDown"
        static let needsGlassCleaner = "needsGlassCleaner"
        static let needsRag = "needsRag"
    }
    
    //MARK: Initialization
    
    init?(name: String, location: String, lastUpdated: Date, needsService: Bool,
          isDown: Bool, needsGlassCleaner: Bool, needsRag: Bool) {
        
        if name.isEmpty  {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.location = location
        self.lastUpdated = lastUpdated
        self.needsService = needsService
        self.isDown = isDown
        self.needsGlassCleaner = needsGlassCleaner
        self.needsRag = needsRag
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let location = aDecoder.decodeObject(forKey: PropertyKey.location) as? String
        let lastUpdated = aDecoder.decodeObject(forKey: PropertyKey.lastUpdated) as? Date
        let needsService = aDecoder.decodeBool(forKey: PropertyKey.needsService)
        let isDown = aDecoder.decodeBool(forKey: PropertyKey.isDown)
        let needsGlassCleaner = aDecoder.decodeBool(forKey: PropertyKey.needsGlassCleaner)
        let needsRag = aDecoder.decodeBool(forKey: PropertyKey.needsRag)
        
        // Must call designated initializer.
        self.init(name: name, location: location!, lastUpdated: lastUpdated!, needsService: needsService,
                  isDown: isDown, needsGlassCleaner: needsGlassCleaner, needsRag: needsRag)
    }
    
    func getStatus() -> String {
        var message = ""
        
        if isDown {
            message += "Down; needs service. "
        } else if needsService {
            message += "Functional, but needs service. "
        }
        if needsGlassCleaner {
            message += "Needs glass cleaner. "
        }
        if needsRag {
            message += "Needs rag. "
        }
        
        return message
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(location, forKey: PropertyKey.location)
        aCoder.encode(lastUpdated, forKey: PropertyKey.lastUpdated)
        aCoder.encode(needsService, forKey: PropertyKey.needsService)
        aCoder.encode(isDown, forKey: PropertyKey.isDown)
        aCoder.encode(needsGlassCleaner, forKey: PropertyKey.needsGlassCleaner)
        aCoder.encode(needsRag, forKey: PropertyKey.needsRag)
    }
}
