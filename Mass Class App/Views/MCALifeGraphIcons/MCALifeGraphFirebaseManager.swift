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
    
    // TODO: The better way to do this is to keep track of changes only and upload those, but this works fine for now and is faster
    
    private func encodeContentView(_ contentView: UIView) -> MCAlifeGraphContentsCodable {
        
        var childIcons = [MCALifeGraphIconBaseViewCodable]()
        var childNoteIcons = [MCALifeGraphIconNoteViewCodable]()
        var childIconImages = [MCALifeImageIconViewCodable]()
        
        for view in contentView.subviews {
            //This is a bad way to do this. It works, but we have to check for subclasses first since they all inherit from the same base class.
            if view.isKind(of: MCALifeGraphIconNoteView.self) {
                let viewAsNote = view as! MCALifeGraphIconNoteView
                let text = viewAsNote.textView.text
                let newNoteCodable = MCALifeGraphIconNoteViewCodable(frame: view.frame,
                                                                     identifier:viewAsNote.identifier!,
                                                                     bgColor: MCAColor(red: 1, blue: 1, green: 1, alpha: 1),
                                                                     noteContents: text!)
                childNoteIcons.append(newNoteCodable)
            } else if view.isKind(of: MCALifeImageIconView.self) {
                let viewAsImageIcon = view as! MCALifeImageIconView
                let newImageCodable = MCALifeImageIconViewCodable(frame: view.frame,
                                                                  identifier: viewAsImageIcon.identifier!,
                                                                  bgColor: MCAColor(red: 1, blue: 1, green: 1, alpha: 1),
                                                                  imageLocation: "none yet")
                childIconImages.append(newImageCodable)
            } else if view.isKind(of: MCALifeGraphIconBaseView.self) {
                let viewAsBaseIcon = view as!  MCALifeGraphIconBaseView
                let newIconCodable = MCALifeGraphIconBaseViewCodable(frame: view.frame,
                                                                     identifier: viewAsBaseIcon.identifier!,
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
    
    func uploadContentToFirebase(for graph: LifeGraphOptions) {
        
        guard let graphContentView = contentView else { return }
        let contents = encodeContentView(graphContentView)
        let testData = try! JSONEncoder().encode(contents)
        let string = String(data: testData, encoding: .utf8)
        print(string)
        
        let firData = try! FirebaseEncoder().encode(contents)
        
        ref = Database.database().reference()
        guard let userIdentifier = Auth.auth().currentUser?.uid else {
            print("not logged in!")
            return
        }
        ref.child(userIdentifier).child(graph.rawValue).setValue(firData)
        
        //        self.ref = Database.datab
    }
    
    // TODO: Completion handler here maybe
    func decodeViewsFromFirebase(for graph: LifeGraphOptions, completion: @escaping (MCAlifeGraphContentsCodable?) -> Void) {
        var contents: MCAlifeGraphContentsCodable?
        
        guard let userIdentifier = Auth.auth().currentUser?.uid else {
            print("not logged in!")
            return
        }
        ref = Database.database().reference()
        
        ref.child(userIdentifier).child(graph.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value else { return }
            
            
            do {
                let model = try FirebaseDecoder().decode(MCAlifeGraphContentsCodable.self, from: value)
                completion(model)
            } catch let error {
                completion(nil)
                print(error)
            }
        })
        //        handle = ref.child(userIdentifier).child("my first graph").observe(.childAdded, with: { (snapshot) in
        //
        //        })
    }
    
    func convertModelToViews(_ model: MCAlifeGraphContentsCodable) -> [MCALifeGraphIconBaseView] {
        var views = [MCALifeGraphIconBaseView]()
        
        if let childIcons = model.childIcons {
            for icons in childIcons {
                //TODO: add BG color
                let newIcon = MCALifeGraphIconBaseView(frame: icons.frame, bgColor: UIColor.white, identifier: icons.identifier)
                views.append(newIcon)
            }
        }
        
        if let childNotes = model.childNoteIcons {
            for icons in childNotes {
                let newNote = MCALifeGraphIconNoteView(frame: icons.frame
                    , textToDisplay: icons.noteContents)
                views.append(newNote)
            }
        }
        if let childImages = model.childImageIcons {
            for icons in childImages {
                let newImage = MCALifeImageIconView(frame: icons.frame
                    , identifier: icons.identifier)
                views.append(newImage)
            }
            
        }
        
        return views
    }
    
    
    
}
