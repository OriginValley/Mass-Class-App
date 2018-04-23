//
//  MCALifeGraphFirebaseManager.swift
//  Mass Class App
//
//  Created by Christian Flanders on 4/22/18.
//  Copyright © 2018 Origin Valley. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CodableFirebase

class MCALifeGraphFirebaseManager {
    
    var contentView: UIView!
    
    
    var ref: DatabaseReference!
    var handle: DatabaseHandle!
    
    func encodeContentView(_ contentView: UIView) -> MCAlifeGraphContentsCodable {
        
        var childIcons = [MCALifeGraphIconBaseViewCodable]()
        var childNoteIcons = [MCALifeGraphIconNoteViewCodable]()
        var childIconImages = [MCALifeImageIconViewCodable]()
        
        for view in contentView.subviews {
            //This is a bad way to do this. It works, but we have to check for subclasses first since they all inherit from the same base class.
            if view.isKind(of: MCALifeGraphIconNoteView.self) {
                let newNoteCodable = MCALifeGraphIconNoteViewCodable(frame: view.frame,
                                                                     identifier: "identifier",
                                                                     bgColor: MCAColor(red: 1, blue: 1, green: 1, alpha: 1),
                                                                     noteContents: "blah blah blah blah")
                childNoteIcons.append(newNoteCodable)
            } else if view.isKind(of: MCALifeImageIconView.self) {
                let newImageCodable = MCALifeImageIconViewCodable(frame: view.frame,
                                                                  identifier: "identifier",
                                                                  bgColor: MCAColor(red: 1, blue: 1, green: 1, alpha: 1),
                                                                  imageLocation: "none yet")
                childIconImages.append(newImageCodable)
            } else if view.isKind(of: MCALifeGraphIconBaseView.self) {
                let newIconCodable = MCALifeGraphIconBaseViewCodable(frame: view.frame,
                                                                     identifier: "identifier",
                                                                     bgColor: MCAColor(red: 1, blue: 1, green: 1, alpha: 1))
                childIcons.append(newIconCodable)
                
            }
            
        }
        
        let newLifeGraphCodable = MCAlifeGraphContentsCodable(graphIdentifier: "My Graph",
                                                              graphBackgroundColor: MCAColor(red: 1, blue: 1, green: 1, alpha: 1),
                                                              childIcons: childIcons,
                                                              childNoteIcons: childNoteIcons,
                                                              childImageIcons: childIconImages)
        return newLifeGraphCodable
        //        let jsonEncoder = JSONEncoder()
        //        let graphJSONData = try! jsonEncoder.encode(newLifeGraphCodable)
        //        return graphJSONData
    }
    
    func uploadContentToFirebase() {
        
        guard let graphContentView = contentView else { return }
        let contents = encodeContentView(graphContentView)
        let firData = try! FirebaseEncoder().encode(contents)
        ref = Database.database().reference()
        guard let userIdentifier = Auth.auth().currentUser?.uid else {
            print("not logged in!")
            return
        }
        ref.child(userIdentifier).child("my first graph").setValue(firData)
        
        //        self.ref = Database.datab
    }
    
    // TODO: Completion handler here maybe
    func decodeViewsFromFirebase(completion: @escaping (MCAlifeGraphContentsCodable) -> Void) {
        var contents: MCAlifeGraphContentsCodable?
        
        guard let userIdentifier = Auth.auth().currentUser?.uid else {
            print("not logged in!")
            return
        }
        ref = Database.database().reference()

        ref.child(userIdentifier).child("my first graph").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value else { return }
            
            
            do {
                let model = try FirebaseDecoder().decode(MCAlifeGraphContentsCodable.self, from: value)
                completion(model)
            } catch let error {
                print(error)
            }
        })
//        handle = ref.child(userIdentifier).child("my first graph").observe(.childAdded, with: { (snapshot) in
//
//        })
}
    
    func convertModelToViews(_ model: MCAlifeGraphContentsCodable) -> [MCALifeGraphIconBaseView] {
        var views = [MCALifeGraphIconBaseView]()
        
        let childIcons = model.childIcons
        
        for icons in childIcons {
            //TODO: add BG color
            let newIcon = MCALifeGraphIconBaseView(frame: icons.frame)
            views.append(newIcon)
        }
        
        let childNotes = model.childNoteIcons
        for icons in childNotes {
            let newNote = MCALifeGraphIconNoteView(frame: icons.frame
                , textToDisplay: icons.noteContents)
            views.append(newNote)
        }
        let childImages = model.childImageIcons
        
        for icons in childImages {
            let newImage = MCALifeImageIconView(frame: icons.frame
                , image: #imageLiteral(resourceName: "Company"))
            views.append(newImage)
        }
        return views
    }



}
