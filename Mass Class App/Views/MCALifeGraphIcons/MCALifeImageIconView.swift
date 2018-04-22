//
//  MCALifeImageIconView.swift
//  Mass Class App
//
//  Created by Christian Flanders on 4/21/18.
//  Copyright © 2018 Origin Valley. All rights reserved.
//

import Foundation
import UIKit

class MCALifeImageIconView: MCALifeGraphIconBaseView {
    
    var displayImage: UIImage!
    
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
    

    func storeImageInFirebase() {
        
    }
    
    func retrieveImageFromFirebase(imageNamed: String) {
        
    }
    
    
    func addImageView() {
        let imageView = UIImageView(frame: self.bounds)
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        guard let image = displayImage else { fatalError("Got too far with no image")}
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        self.addSubview(imageView)
        self.bringSubview(toFront: imageView)
    }
}
