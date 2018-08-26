//
//  LaserPrinterBoothViewController.swift
//  BoothTracker
//
//  Created by Ty Morrow on 8/25/18.
//  Copyright © 2018 Ty Morrow. All rights reserved.
//

import UIKit
import os.log

class LaserPrinterBoothViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var cartridgesTextField: UITextField!
    @IBOutlet weak var cartridgesStepper: UIStepper!
    @IBOutlet weak var paperRollsTextField: UITextField!
    @IBOutlet weak var paperRollsStepper: UIStepper!
    @IBOutlet weak var needsServiceSwitch: UISwitch!
    @IBOutlet weak var isDownSwitch: UISwitch!
    @IBOutlet weak var needsGlassCleanerSwitch: UISwitch!
    @IBOutlet weak var needsRagSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    /*
     This value is either passed by `BoothTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new booth.
     */
    var laserPrinterBooth: LaserPrinterBooth?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let booth = laserPrinterBooth {
            nameTextField.text = booth.name
            locationTextField.text = booth.location
            cartridgesStepper.value = Double(booth.cartridgeStock)
            cartridgesTextField.text = String(format: "%.0f", cartridgesStepper.value)
            paperRollsStepper.value = Double(booth.paperRollStock)
            paperRollsTextField.text = String(format: "%.0f", paperRollsStepper.value)
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
    
    @IBAction func cartridgeStepperChanged(_ sender: UIStepper) {
        cartridgesTextField.text = String(format: "%.0f", sender.value)
    }
    
    @IBAction func paperRollsStepperChanged(_ sender: UIStepper) {
        paperRollsTextField.text = String(format: "%.0f", sender.value)
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
            fatalError("The LaserPrinterBoothViewController is not inside a navigation controller.")
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
        let cartridgeStock = UInt(cartridgesStepper.value)
        let paperRollStock = UInt(paperRollsStepper.value)
        let needsService = needsServiceSwitch.isOn
        let isDown = isDownSwitch.isOn
        let needsGlassCleaner = needsGlassCleanerSwitch.isOn
        let needsRag = needsRagSwitch.isOn
        
        laserPrinterBooth = LaserPrinterBooth(name: name, location: location, lastUpdated: Date(), needsService: needsService,
                                              isDown: isDown, needsGlassCleaner: needsGlassCleaner, needsRag: needsRag,
                                              cartridgeStock: cartridgeStock, paperRollStock: paperRollStock)
    }
}

