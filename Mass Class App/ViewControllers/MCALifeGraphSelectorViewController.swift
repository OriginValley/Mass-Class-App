//
//  MCALifeGraphSelectorViewController.swift
//  Mass Class App
//
//  Created by Christian Flanders on 4/23/18.
//  Copyright © 2018 Origin Valley. All rights reserved.
//

import UIKit

class MCALifeGraphSelectorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func pastButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func presentButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func futureButtonPressed(_ sender: UIButton) {
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! MCALifeGraphViewController
        switch segue.identifier {
        case "Past":
           destination.loadedGraph = .past
        case "Present":
            destination.loadedGraph = .present
        case "Future":
            destination.loadedGraph = .future
        default:
            print("We shoulnd't have hit this")
            
        }
    }
 
 
 

}
