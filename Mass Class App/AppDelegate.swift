//
//  AppDelegate.swift
//  Mass Class App
//
//  Created by Victor Orourke on 4/2/18.
//  Copyright © 2018 Origin Valley. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseTwitterAuthUI
import FirebaseFacebookAuthUI
import FirebasePhoneAuthUI
import GoogleSignIn
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
        -> Bool {
            
            
            FirebaseApp.configure()
            
            FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
            
            TWTRTwitter.sharedInstance().start(withConsumerKey:"AA7kmNYAMX8K5Yg7gAyUCbV3Z", consumerSecret:"QSdgTg3HeGW6PvWO4N3zuUlHvOlSYyE92NU2XusNYEE4fwKdUc")
            
            setupFIRAuth()
            
            return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    
    
    // MARK: FIR Authentication
    private func setupFIRAuth() {
        
        let authUI = FUIAuth.defaultAuthUI()
        
        authUI?.delegate = self
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            FUIFacebookAuth(),
            FUITwitterAuth(),
            ]
        
        authUI?.providers = providers
        
        checkForAuth()
        
    }
    
    private func checkForAuth() {
        if Auth.auth().currentUser == nil {
            showAuthVC()
        } else {
            showMainScreen()
        }
    }
    
    private func showAuthVC() {
        let authViewController = FUIAuth.defaultAuthUI()?.authViewController()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = authViewController
        self.window?.makeKeyAndVisible()
    }
    
    private func showMainScreen() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let userVC = storyBoard.instantiateViewController(withIdentifier: "LifeGraphNav") as! UINavigationController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = userVC
        self.window?.makeKeyAndVisible()
    }
    
    private func isUserLoggedIn() -> Bool {
        if Auth.auth().currentUser == nil {
            return false
        } else {
            return true
        }
    }
    
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Mass_Class_App")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was. test
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}


extension AppDelegate: FUIAuthDelegate {
    
    internal func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        showMainScreen()
        
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        
        return MCAAuthPickerViewController(nibName: "MCAAuthPickerView", bundle: nil, authUI: authUI)
        
    }
    
}


extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        showMainScreen()
        
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //use image here!
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}







