//
//  InkPrinterBoothViewController.swift
//  BoothTracker
//
//  Created by Ty Morrow on 8/25/18.
//  Copyright © 2018 Ty Morrow. All rights reserved.
//

import UIKit
import os.log

class InkPrinterBoothViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var cyanInkTextField: UITextField!
    @IBOutlet weak var cyanInkStepper: UIStepper!
    @IBOutlet weak var magentaInkTextField: UITextField!
    @IBOutlet weak var magentaInkStepper: UIStepper!
    @IBOutlet weak var yellowInkTextField: UITextField!
    @IBOutlet weak var yellowInkStepper: UIStepper!
    @IBOutlet weak var blackInkTextField: UITextField!
    @IBOutlet weak var blackInkStepper: UIStepper!
    @IBOutlet weak var tonerTextField: UITextField!
    @IBOutlet weak var tonerStepper: UIStepper!
    @IBOutlet weak var paperTextField: UITextField!
    @IBOutlet weak var paperStepper: UIStepper!
    @IBOutlet weak var needsCleaningSheetsSwitch: UISwitch!
    @IBOutlet weak var needsServiceSwitch: UISwitch!
    @IBOutlet weak var isDownSwitch: UISwitch!
    @IBOutlet weak var needsGlassCleanerSwitch: UISwitch!
    @IBOutlet weak var needsRagSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    /*
     This value is either passed by `BoothTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new booth.
     */
    var inkPrinterBooth: InkPrinterBooth?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let booth = inkPrinterBooth {
            nameTextField.text = booth.name
            locationTextField.text = booth.location
            cyanInkStepper.value = Double(booth.cyanInkStock)
            cyanInkTextField.text = String(format: "%.0f", cyanInkStepper.value)
            magentaInkStepper.value = Double(booth.magentaInkStock)
            magentaInkTextField.text = String(format: "%.0f", magentaInkStepper.value)
            yellowInkStepper.value = Double(booth.yellowInkStock)
            yellowInkTextField.text = String(format: "%.0f", yellowInkStepper.value)
            blackInkStepper.value = Double(booth.blackInkStock)
            blackInkTextField.text = String(format: "%.0f", blackInkStepper.value)
            tonerStepper.value = Double(booth.tonerStock)
            tonerTextField.text = String(format: "%.0f", tonerStepper.value)
            paperStepper.value = Double(booth.paperStock)
            paperTextField.text = String(format: "%.0f", paperStepper.value)
            needsCleaningSheetsSwitch.isOn = booth.needsCleaningSheets
            needsServiceSwitch.isOn = booth.needsService
            isDownSwitch.isOn = booth.isDown
            needsGlassCleanerSwitch.isOn = booth.needsGlassCleaner
            needsRagSwitch.isOn = booth.needsRag
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func cyanInkStepperChanged(_ sender: UIStepper) {
        cyanInkTextField.text = String(format: "%.0f", sender.value)
    }
    
    @IBAction func magentaInkStepperChanged(_ sender: UIStepper) {
        magentaInkTextField.text = String(format: "%.0f", sender.value)
    }
    
    @IBAction func yellowInkStepperChanged(_ sender: UIStepper) {
        yellowInkTextField.text = String(format: "%.0f", sender.value)
    }
    
    @IBAction func blackInkStepperChanged(_ sender: UIStepper) {
        blackInkTextField.text = String(format: "%.0f", sender.value)
    }
    
    @IBAction func tonerStepperChanged(_ sender: UIStepper) {
        tonerTextField.text = String(format: "%.0f", sender.value)
    }
    
    @IBAction func paperStepperChanged(_ sender: UIStepper) {
        paperTextField.text = String(format: "%.0f", sender.value)
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddBoothMode = presentingViewController is UINavigationController
        
        if isPresentingInAddBoothMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The InkPrinterBoothViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = nameTextField.text ?? ""
        let location = locationTextField.text ?? ""
        let cyanInkStock = UInt(cyanInkStepper.value)
        let magentaInkStock = UInt(magentaInkStepper.value)
        let yellowInkStock = UInt(yellowInkStepper.value)
        let blackInkStock = UInt(blackInkStepper.value)
        let tonerStock = UInt(tonerStepper.value)
        let paperStock = UInt(paperStepper.value)
        let needsCleaningSheets = needsCleaningSheetsSwitch.isOn
        let needsService = needsServiceSwitch.isOn
        let isDown = isDownSwitch.isOn
        let needsGlassCleaner = needsGlassCleanerSwitch.isOn
        let needsRag = needsRagSwitch.isOn
        
        inkPrinterBooth = InkPrinterBooth(name: name, location: location, lastUpdated: Date(), needsService: needsService,
                                          isDown: isDown, needsGlassCleaner: needsGlassCleaner, needsRag: needsRag,
                                          cyanInkStock: cyanInkStock, magentaInkStock: magentaInkStock, yellowInkStock: yellowInkStock,
                                          blackInkStock: blackInkStock, tonerStock: tonerStock, paperStock: paperStock,
                                          needsCleaningSheets: needsCleaningSheets)
    }
}

