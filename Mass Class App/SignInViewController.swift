//
//  SignInViewController.swift
//  Mass Class App
//
//  Created by Victor Orourke on 4/15/18.
//  Copyright © 2018 Origin Valley. All rights reserved.
//

import Foundation
import UIKit
import Firebase

@objc(SignInViewController)
class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var ref: DatabaseReference!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "signIn", sender: nil)
        }
        ref = Database.database().reference()
    }
    
    // Saves user profile information to user database
    func saveUserInfo(_ user: Firebase.User, withUsername username: String) {
        
        // Create a change request
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = username
        
        // Commit profile changes to server
        changeRequest?.commitChanges() { (error) in
            
            
            
            
            // [START basic_write]
            self.ref.child("users").child(user.uid).setValue(["username": username])
            // [END basic_write]
            self.performSegue(withIdentifier: "signIn", sender: nil)
        }
        
    }
    
    @IBAction func didTapEmailLogin(_ sender: AnyObject) {
        
        guard let email = self.emailField.text, let password = self.passwordField.text else {
            self.showMessagePrompt("email/password can't be empty")
            return
        }
        
        
        // Sign user in
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            
            guard let user = user, error == nil else {
                self.showMessagePrompt(error!.localizedDescription)
                return
            }
            
            self.ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                // Check if user already exists
                guard !snapshot.exists() else {
                    self.performSegue(withIdentifier: "signIn", sender: nil)
                    return
                }
                
                // Otherwise, create the new user account
                self.showTextInputPrompt(withMessage: "Username:") { (userPressedOK, username) in
                    
                    guard let username = username else {
                        self.showMessagePrompt("Username can't be empty")
                        return
                    }
                    
                    self.saveUserInfo(user, withUsername: username)
                }
            }) // End of observeSingleEvent
        }) // End of signIn
    }
    
    @IBAction func didTapSignUp(_ sender: AnyObject) {
        
        func getEmail(completion: @escaping (String) -> ()) {
            self.showTextInputPrompt(withMessage: "Email:") { (userPressedOK, email) in
                guard let email = email else {
                    self.showMessagePrompt("Email can't be empty.")
                    return
                }
                completion(email)
            }
        }
        
        func getUsername(completion: @escaping (String) -> ()) {
            self.showTextInputPrompt(withMessage: "Username:") { (userPressedOK, username) in
                guard let username = username else {
                    self.showMessagePrompt("Username can't be empty.")
                    return
                }
                completion(username)
            }
        }
        
        func getPassword(completion: @escaping (String) -> ()) {
            
            self.showTextInputPrompt(withMessage: "Password:") { (userPressedOK, password) in
                guard let password = password else {
                    self.showMessagePrompt("Password can't be empty.")
                    return
                }
                completion(password)
            }
        }
        
        // Get the credentials of the user
        getEmail { email in
            getUsername { username in
                getPassword { password in
                    
                    // Create the user with the provided credentials
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        
                        guard let user = user, error == nil else {
                            self.showMessagePrompt(error!.localizedDescription)
                            return
                        }
                        
                        // Finally, save their profile
                        self.saveUserInfo(user, withUsername: username)
                        
                    })
                }
            }
        }
        
    }
    
    // MARK: - UITextFieldDelegate protocol methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapEmailLogin(textField)
        return true
    }
}
