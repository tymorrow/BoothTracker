//
//  InkPrinterBooth.swift
//  BoothTracker
//
//  Created by Ty Morrow on 8/25/18.
//  Copyright © 2018 Ty Morrow. All rights reserved.
//

import UIKit
import os.log

class InkPrinterBooth: Booth {
    
    //MARK: Properties
    
    var cyanInkStock: UInt = 0
    var magentaInkStock: UInt = 0
    var yellowInkStock: UInt = 0
    var blackInkStock: UInt = 0
    var tonerStock: UInt = 0
    var paperStock: UInt = 0
    var needsCleaningSheets: Bool = false
    
    //MARK: Types
    
    struct InkPrinterBoothPropertyKey {
        static let cyanInkStock = "cyanInkStock"
        static let magentaInkStock = "magentaInkStock"
        static let yellowInkStock = "yellowInkStock"
        static let blackInkStock = "blackInkStock"
        static let tonerStock = "tonerStock"
        static let paperStock = "paperStock"
        static let needsCleaningSheets = "needsCleaningSheets"
    }
    
    init?(name: String, location: String, lastUpdated: Date, needsService: Bool,
          isDown: Bool, needsGlassCleaner: Bool, needsRag: Bool,
          cyanInkStock: UInt, magentaInkStock: UInt, yellowInkStock: UInt,
          blackInkStock: UInt, tonerStock: UInt, paperStock: UInt, needsCleaningSheets: Bool) {
        self.cyanInkStock = cyanInkStock
        self.magentaInkStock = magentaInkStock
        self.yellowInkStock = yellowInkStock
        self.blackInkStock = blackInkStock
        self.tonerStock = tonerStock
        self.paperStock = paperStock
        self.needsCleaningSheets = needsCleaningSheets
        
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
        let cyanInkStock = aDecoder.decodeObject(forKey: InkPrinterBoothPropertyKey.cyanInkStock) as? UInt ?? 0
        let magentaInkStock = aDecoder.decodeObject(forKey: InkPrinterBoothPropertyKey.magentaInkStock) as? UInt ?? 0
        let yellowInkStock = aDecoder.decodeObject(forKey: InkPrinterBoothPropertyKey.yellowInkStock) as? UInt ?? 0
        let blackInkStock = aDecoder.decodeObject(forKey: InkPrinterBoothPropertyKey.blackInkStock) as? UInt ?? 0
        let tonerStock = aDecoder.decodeObject(forKey: InkPrinterBoothPropertyKey.tonerStock) as? UInt ?? 0
        let paperStock = aDecoder.decodeObject(forKey: InkPrinterBoothPropertyKey.paperStock) as? UInt ?? 0
        let needsCleaningSheets = aDecoder.decodeBool(forKey: InkPrinterBoothPropertyKey.needsCleaningSheets)
        
        // Must call designated initializer.
        self.init(name: name, location: location!, lastUpdated: lastUpdated!, needsService: needsService,
                  isDown: isDown, needsGlassCleaner: needsGlassCleaner, needsRag: needsRag,
                  cyanInkStock: cyanInkStock, magentaInkStock: magentaInkStock, yellowInkStock: yellowInkStock,
                  blackInkStock: blackInkStock, tonerStock: tonerStock, paperStock: paperStock,
                  needsCleaningSheets: needsCleaningSheets)
    }
    
    //MARK: Methods
    
    override func getStatus() -> String {
        var message = super.getStatus()
        
        if cyanInkStock <= 0 || magentaInkStock <= 0 || yellowInkStock <= 0 || blackInkStock <= 0 ||
            tonerStock <= 0 || paperStock <= 0 || needsCleaningSheets {
            message += "Needs supplies. "
        }
        else if cyanInkStock == 1 || magentaInkStock == 1 || yellowInkStock == 1 || blackInkStock == 1 ||
            tonerStock == 1 || paperStock == 1 {
            message += "Low supplies. "
        }
        
        return message
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        
        aCoder.encode(cyanInkStock, forKey: InkPrinterBoothPropertyKey.cyanInkStock)
        aCoder.encode(magentaInkStock, forKey: InkPrinterBoothPropertyKey.magentaInkStock)
        aCoder.encode(yellowInkStock, forKey: InkPrinterBoothPropertyKey.yellowInkStock)
        aCoder.encode(blackInkStock, forKey: InkPrinterBoothPropertyKey.blackInkStock)
        aCoder.encode(tonerStock, forKey: InkPrinterBoothPropertyKey.tonerStock)
        aCoder.encode(paperStock, forKey: InkPrinterBoothPropertyKey.paperStock)
        aCoder.encode(needsCleaningSheets, forKey: InkPrinterBoothPropertyKey.needsCleaningSheets)
    }
}
