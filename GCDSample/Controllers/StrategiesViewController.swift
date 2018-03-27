//
//  StartegiesTableViewController.swift
//  GCDSample
//
//  Created by Fernando Rodriguez on 3/22/18.
//  Copyright © 2018 Fernando Rodriguez. All rights reserved.
//

import UIKit

class StrategiesViewController: UITableViewController {

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identificator = segue.identifier else{
            
            print("\(segue) has  no id")
            return
        }
        
        guard let destinationVC = segue.destination as? DownloadViewController else{
            print("\(segue) has the wrong type of destination")
            return
        }
        
        destinationVC.segueId = identificator
        
        
    }

}
