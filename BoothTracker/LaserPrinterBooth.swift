//
//  LaserPrinterBooth.swift
//  BoothTracker
//
//  Created by Ty Morrow on 8/25/18.
//  Copyright © 2018 Ty Morrow. All rights reserved.
//

import UIKit
import os.log

class LaserPrinterBooth: Booth {
    
    //MARK: Properties
    
    var cartridgeStock: UInt = 0
    var paperRollStock: UInt = 0
    
    //MARK: Types
    
    struct LaserPrinterBoothPropertyKey {
        static let cartridgeStock = "cartridgeStock"
        static let paperRollStock = "paperRollStock"
    }
    
    init?(name: String, location: String, lastUpdated: Date, needsService: Bool,
          isDown: Bool, needsGlassCleaner: Bool, needsRag: Bool,
          cartridgeStock: UInt, paperRollStock: UInt) {
        self.cartridgeStock = cartridgeStock
        self.paperRollStock = paperRollStock
        
        super.init(name: name, location: location, lastUpdated: lastUpdated,
                   needsService: needsService, isDown: isDown,
                   needsGlassCleaner: needsGlassCleaner, needsRag: needsRag)
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
        let cartridgeStock = aDecoder.decodeObject(forKey: LaserPrinterBoothPropertyKey.cartridgeStock) as? UInt ?? 0
        let paperRollStock = aDecoder.decodeObject(forKey: LaserPrinterBoothPropertyKey.paperRollStock) as? UInt ?? 0
        
        // Must call designated initializer.
        self.init(name: name, location: location!, lastUpdated: lastUpdated!, needsService: needsService,
                  isDown: isDown, needsGlassCleaner: needsGlassCleaner, needsRag: needsRag,
                  cartridgeStock: cartridgeStock, paperRollStock: paperRollStock)
    }
    
    override func getStatus() -> String {
        var message = super.getStatus()
        
        if cartridgeStock <= 0 || paperRollStock <= 0 {
            message += "Needs supplies. "
        }
        else if cartridgeStock == 1 || paperRollStock == 1 {
            message += "Low supplies. "
        }
        
        return message
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        
        aCoder.encode(cartridgeStock, forKey: LaserPrinterBoothPropertyKey.cartridgeStock)
        aCoder.encode(paperRollStock, forKey: LaserPrinterBoothPropertyKey.paperRollStock)
    }
}
