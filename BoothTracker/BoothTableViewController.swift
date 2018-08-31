//
//  BoothTableViewController.swift
//  BoothTracker
//
//  Created by Ty Morrow on 8/25/18.
//  Copyright © 2018 Ty Morrow. All rights reserved.
//

import UIKit
import os.log

class BoothTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var booths = [Booth]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedBooths = loadBooths() {
            booths += savedBooths
        }
        else {
            // Load the sample data.
            loadSampleBooths()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booths.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "BoothTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BoothTableViewCell  else {
            fatalError("The dequeued cell is not an instance of BoothTableViewCell.")
        }
        
        // Fetches the appropriate booth for the data source layout.
        let booth = booths[indexPath.row]
        
        cell.nameLabel.text = booth.name
        cell.locationLabel.text = booth.location
        let statusMsg = booth.getStatus()
        cell.statusLabel.text = statusMsg
        if statusMsg.lowercased().range(of:"need") != nil {
            cell.statusLabel.textColor = UIColor.red
        }
        else if statusMsg.lowercased().range(of:"low") != nil {
            cell.statusLabel.textColor = UIColor.orange
        }
        else {
            cell.statusLabel.textColor = UIColor.gray
        }
        let diffInDays = Calendar.current.dateComponents([.day], from: booth.lastUpdated, to: Date()).day ?? 0
        if diffInDays == 0 {
            cell.lastUpdateLabel.text = "< 1 day ago"
        }
        else if diffInDays == 1 {
            cell.lastUpdateLabel.text = "1 day ago"
        }
        else {
            cell.lastUpdateLabel.text = "\(diffInDays) days ago"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedBooth = booths[indexPath.row] as? InkPrinterBooth {
            self.performSegue(withIdentifier: "ShowInkPrinterBoothDetail", sender: selectedBooth)
        }
        else if let selectedBooth = booths[indexPath.row] as? LaserPrinterBooth {
            self.performSegue(withIdentifier: "ShowLaserPrinterBoothDetail", sender: selectedBooth)
        }
        else {
            fatalError("Unexpected booth type")
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            booths.remove(at: indexPath.row)
            saveBooths()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            case "AddItem":
                os_log("Adding a new booth.", log: OSLog.default, type: .debug)
            case "ShowInkPrinterBoothDetail":
                os_log("Navigating to ink printer booth detail")
                if let selectedBooth = sender as? InkPrinterBooth {
                    guard let boothDetailViewController = segue.destination as? InkPrinterBoothViewController else {
                        fatalError("Unexpected destination: \(segue.destination)")
                    }
                    
                    boothDetailViewController.inkPrinterBooth = selectedBooth
                }
                else {
                    fatalError("Unexpected booth type")
            }
            case "ShowLaserPrinterBoothDetail":
                os_log("Navigating to laser printer booth detail")
                if let selectedBooth = sender as? LaserPrinterBooth {
                    guard let boothDetailViewController = segue.destination as? LaserPrinterBoothViewController else {
                        fatalError("Unexpected destination: \(segue.destination)")
                    }

                    boothDetailViewController.laserPrinterBooth = selectedBooth
                }
                else {
                    fatalError("Unexpected booth type")
                }
            default:
                fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "unknown")")
        }
    }
    
    //MARK: Actions
    
    @IBAction func unwindToBoothList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? LaserPrinterBoothViewController, let booth = sourceViewController.laserPrinterBooth {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing booth
                booths[selectedIndexPath.row] = booth
            }
            else {
                // Add a new booth
                booths.append(booth)
            }
            booths.sort(by: { $0.name.lowercased() < $1.name.lowercased() })
            tableView.reloadData()
            saveBooths()
        }
        
        if let sourceViewController = sender.source as? InkPrinterBoothViewController, let booth = sourceViewController.inkPrinterBooth {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing booth
                booths[selectedIndexPath.row] = booth
            }
            else {
                // Add a new booth
                booths.append(booth)
            }
            booths.sort(by: { $0.name.lowercased() < $1.name.lowercased() })
            tableView.reloadData()
            saveBooths()
        }
    }
    
    //MARK: Private Methods
    
    private func loadSampleBooths() {
        guard let booth1 = InkPrinterBooth(name: "Ink Printer Booth", location: "Somewhere", lastUpdated: Date(),
                                           needsService: false, isDown: false, needsGlassCleaner: false, needsRag: false,
                                           cyanInkStock: 2, magentaInkStock: 2, yellowInkStock: 3,
                                           blackInkStock: 3, tonerStock: 2, paperStock: 2,
                                           needsCleaningSheets: false) else {
            fatalError("Failed to create booth 1")
        }
        guard let booth2 = LaserPrinterBooth(name: "Laser Printer Booth", location: "Nowhere", lastUpdated: Date(),
                                             needsService: false, isDown: false, needsGlassCleaner: false, needsRag: false,
                                             cartridgeStock: 2, paperRollStock: 1) else {
            fatalError("Failed to create booth 2")
        }
        booths += [booth1, booth2]
    }
    
    private func saveBooths() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(booths, toFile: Booth.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Booths successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save booths...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadBooths() -> [Booth]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Booth.ArchiveURL.path) as? [Booth]
    }
}
