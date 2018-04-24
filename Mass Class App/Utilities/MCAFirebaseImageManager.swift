//
//  MCAFirebaseImageManager.swift
//  Mass Class App
//
//  Created by Christian Flanders on 4/24/18.
//  Copyright © 2018 Origin Valley. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class MCAFirebaseImageManager {
    
    func retrieveImageFromFirebase(imageNamed: String, completion: @escaping (UIImage?, Error?) -> Void) {
        guard let userImageRef = getUserImageStorageReference() else {
            print("problem with user images reference")
            return
        }
        let imageRefToGrab = userImageRef.child(imageNamed)
        imageRefToGrab.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                completion(nil, error)
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                completion(image, nil)
            }
        }
    }
    
    func storeImageInFirebase(image: UIImage, name: String) {
        
        guard let userImageRef = getUserImageStorageReference() else {
            print("problem with user images reference")
            return
        }

        guard let imageData = UIImagePNGRepresentation(image) else {
            print("problem converting image data")
            return
        }
        
        let thisImageRef = userImageRef.child(name)
        thisImageRef.putData(imageData)
    }
    
    private func getUserImageStorageReference() -> StorageReference? {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        guard let userID = Auth.auth().currentUser?.uid else { return nil }
        let userImagesRef = storageRef.child(userID)
        return userImagesRef
    }

    
}
