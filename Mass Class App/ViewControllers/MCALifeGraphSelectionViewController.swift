//
//  MCALifeGraphSelectionViewController.swift
//  Mass Class App
//
//  Created by Christian Flanders on 4/21/18.
//  Copyright © 2018 Origin Valley. All rights reserved.
//

import UIKit

class MCALifeGraphSelectionViewController: UIViewController {

    
    @IBOutlet weak var addIconButton: UIButton!
    @IBOutlet weak var addNoteButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var changeBackgroundButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setCosmetics()
    }

    
    func setCosmetics() {
        addIconButton.drawCornerRadius(Constants.buttonCornerRadius)
        addNoteButton.drawCornerRadius(Constants.buttonCornerRadius)
        addImageButton.drawCornerRadius(Constants.buttonCornerRadius)
        changeBackgroundButton.drawCornerRadius(Constants.buttonCornerRadius)
    }
    
    @IBAction func addIconButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func addNoteButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func addImageButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func changeBackgroundButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
