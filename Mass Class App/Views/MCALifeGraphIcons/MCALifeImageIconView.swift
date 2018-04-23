//
//  MCALifeImageIconView.swift
//  Mass Class App
//
//  Created by Christian Flanders on 4/21/18.
//  Copyright © 2018 Origin Valley. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SDWebImage


class MCALifeImageIconView: MCALifeGraphIconBaseView {
    
    var displayImage: UIImage!
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(frame: CGRect, image: UIImage) {
        self.init(frame: frame)
        self.displayImage = image
        addImageView()
    }
    
    convenience init(frame:CGRect, identifier: String) {
        self.init(frame: frame)
        addImageView()
        self.identifier = identifier
        retrieveImageFromFirebase(imageNamed: identifier)
    }
    
    
    func storeImageInFirebase(image: UIImage) {
        guard let userImageRef = getUserImageStorageReference() else {
            print("problem with user images reference")
            return
        }
        let name = self.identifier!
        guard let imageData = UIImagePNGRepresentation(image) else {
            print("problem converting image data")
            return
        }
        
        let thisImageRef = userImageRef.child(name)
        thisImageRef.putData(imageData)
    }
    
    func retrieveImageFromFirebase(imageNamed: String) {
        guard let userImageRef = getUserImageStorageReference() else {
            print("problem with user images reference")
            return
        }
        let imageRefToGrab = userImageRef.child(imageNamed)
        imageRefToGrab.downloadURL { (url, error) in
            if url != nil {
                self.imageView!.sd_setImage(with: url!, placeholderImage: nil)
            } else {
                print(error)
            }
        }
        // TODO: Set a placeholder download image. Or block UI with a screen, not sure.
        
        
    }
    
    private func getUserImageStorageReference() -> StorageReference? {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        guard let userID = Auth.auth().currentUser?.uid else { return nil }
        let userImagesRef = storageRef.child(userID)
        return userImagesRef
    }
    
    
    func addImageView() {
        imageView = UIImageView(frame: self.bounds)
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // TODO: Maybe extract this into it's own function, so we set the image seperatly from creating the imageview
        
        if let image = displayImage {
            imageView.image = image
            storeImageInFirebase(image: image)
        }
        imageView.contentMode = .scaleAspectFill
        self.addSubview(imageView)
        self.bringSubview(toFront: imageView)
    }
}
