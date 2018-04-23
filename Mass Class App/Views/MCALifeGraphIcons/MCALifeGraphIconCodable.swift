//
//  MCALifeGraphIconCodable.swift
//  Mass Class App
//
//  Created by Christian Flanders on 4/22/18.
//  Copyright © 2018 Origin Valley. All rights reserved.
//

import Foundation
import UIKit

// Ideally, we could just code the actual views down to JSON, but this is faster/less janky overall.

protocol MCALifeGraphIconCodableBase {
    var frame: CGRect { get set }
    var identifier: String { get set }
    var bgColor: MCAColor { get set }
    func convertToView() -> MCALifeGraphIconBaseView
}

struct MCALifeGraphIconBaseViewCodable: MCALifeGraphIconCodableBase, Codable {
    var frame: CGRect
    
    var identifier: String
    
    var bgColor: MCAColor
    
    func convertToView() -> MCALifeGraphIconBaseView {
        return MCALifeGraphIconBaseView(frame: self.frame)
    }
}

struct MCALifeGraphIconNoteViewCodable: MCALifeGraphIconCodableBase, Codable {
    var frame: CGRect
    
    var identifier: String
    
    var bgColor: MCAColor
    
    var noteContents: String
    
    func convertToView() -> MCALifeGraphIconBaseView {
        return MCALifeGraphIconNoteView(frame: self.frame)
    }
    
}

struct MCALifeImageIconViewCodable: MCALifeGraphIconCodableBase, Codable {
    var frame: CGRect
    
    var identifier: String
    
    var bgColor: MCAColor
    
    var imageLocation: String
    
    func convertToView() -> MCALifeGraphIconBaseView {
        return MCALifeImageIconView(frame: self.frame)
    }
}



struct MCAColor: Codable {
    
    var red: Double
    var blue: Double
    var green: Double
    var alpha: Double
    
//    init(uiColor: UIColor) {
//        self.red = uiColor.cgColor.components[0]
//    }
    
}


struct MCAlifeGraphContentsCodable: Codable {
    
    var graphIdentifier: String
    
    var graphBackgroundColor: MCAColor
    
    var childIcons: [MCALifeGraphIconBaseViewCodable]
    
    var childNoteIcons: [MCALifeGraphIconNoteViewCodable]
    
    var childImageIcons: [MCALifeImageIconViewCodable]
    
    
    
}
