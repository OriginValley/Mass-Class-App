//
//  Mass Class Actions
//
//  Created by Victor ORourke.
//  Copyright © 2018 Origin Valley. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI



class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
            let authUI = FUIAuth.defaultAuthUI()
            let authViewController = authUI!.authViewController()
            self.present(authViewController, animated: true, completion: nil)

        } catch  {
            print("Problem signing out")
        }
    }
    
}
