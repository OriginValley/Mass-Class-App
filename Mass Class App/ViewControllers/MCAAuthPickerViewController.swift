//
//  MCAAuthPickerViewController.swift
//  Mass Class App
//
//  Created by Christian Flanders on 4/15/18.
//  Copyright © 2018 Origin Valley. All rights reserved.
//

import Foundation
import FirebaseAuthUI

class MCAAuthPickerViewController: FUIAuthPickerViewController {
    
    private let mainGradientColors = [UIColor.init(named: "Black Color")!.cgColor, UIColor(red: 88/255, green: 86/255, blue: 86/255, alpha: 1.0).cgColor]

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, authUI: FUIAuth) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil, authUI: authUI)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupCosmetics()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setupCosmetics() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.drawGradient(colors: mainGradientColors)
    }
    
    
    
}
