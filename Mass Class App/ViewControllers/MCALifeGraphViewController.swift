//
//  MCALifeGraphViewController.swift
//  Mass Class App
//
//  Created by Christian Flanders on 4/20/18.
//  Copyright © 2018 Origin Valley. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

class MCALifeGraphViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var testTextView: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: contentView.frame)
        imageView.image = #imageLiteral(resourceName: "dots-polka-white-spots-blue-1920x1080-c2-ffffff-40e0d0-l2-15-34-a-315-f-3")
        contentView.addSubview(imageView)
        contentView.sendSubview(toBack: imageView)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    var contentOffset: CGFloat = 20
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.graphActionSequeIdentifier, sender: self)
//        addNewGenericIcon()
//        findOpenSpaceForNewView()
//        addNewGenericIcon()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MCALifeGraphSelectionViewController {
            controller.transitioningDelegate = slideInTransitioningDelegate
            controller.modalPresentationStyle = .custom
        }
    }
    

    func findOpenSpaceForNewView() {
        let newIconSize = Constants.graphIconDefaultSize
        let newIconOrigin = CGPoint(x: 300, y: 300)
        let newIconFrame = CGRect(origin: newIconOrigin, size: Constants.graphIconDefaultSize)
        let newIcon = MCALifeGraphIconBaseView(frame: newIconFrame)
        newIcon.contentView = contentView
        newIcon.scrollView = scrollView
        for views in contentView.subviews {
            if newIcon.frame.intersects(views.frame) {
            }
            
        }
    }
    
    func addNewGenericIcon() {
        let newIconOrigin = CGPoint(x: scrollView.frame.midX, y: scrollView.frame.midY)
        let newIconFrame = CGRect(origin: newIconOrigin, size: Constants.graphIconDefaultSize)
        let newIcon = MCALifeGraphIconBaseView(frame: newIconFrame)
        newIcon.contentView = contentView
        newIcon.scrollView = scrollView
        checkViewForCollisions(view: newIcon)
        contentView.addSubview(newIcon)
        contentView.bringSubview(toFront: newIcon)
    }
    
    func addNoteIcon() {
        let newIconOrigin = CGPoint(x: scrollView.frame.midX, y: scrollView.frame.midY)
        let newIconFrame = CGRect(origin: newIconOrigin, size: Constants.graphIconDefaultSize)
        let newIcon = MCALifeGraphIconNoteView(frame: newIconFrame)
        newIcon.contentView = contentView
        newIcon.scrollView = scrollView
        checkViewForCollisions(view: newIcon)
        contentView.addSubview(newIcon)
        contentView.bringSubview(toFront: newIcon)
    }
    
    func addImageIcon(image: UIImage) {
        let newIconOrigin = CGPoint(x: scrollView.frame.midX, y: scrollView.frame.midY)
        let newIconFrame = CGRect(origin: newIconOrigin, size: Constants.graphIconDefaultSize)
        let newIcon = MCALifeImageIconView(frame: newIconFrame, image: image)
        newIcon.contentView = contentView
        newIcon.scrollView = scrollView
        checkViewForCollisions(view: newIcon)
        contentView.addSubview(newIcon)
        contentView.bringSubview(toFront: newIcon)

    }
    
    @IBAction func unwindToGraph(segue:UIStoryboardSegue) {
        
        
    }

    // TODO: This is bad and you should feel bad. The locations will eventually run out, and the scrolling should have the view in the center
    private func checkViewForCollisions(view: UIView) {
        for views in contentView.subviews {
            if views .isKind(of: MCALifeGraphIconBaseView.self) {
                if view.frame.intersects(views.frame) {
                    print("YES")
//                    view.backgroundColor = UIColor.white
                    view.center.x +=  110
//                    view.center.y += 100
//                    var frameToScroll = view.frame
//                    frameToScroll.origin = self.view.center
                    scrollView.scrollRectToVisible(view.frame, animated: true)
                    checkViewForCollisions(view: view)
                }
                
            }
        }
    }
    

    
    // TODO: I don't love this function...nnot sure why. Look at later
    
    func convertIconsToJSON() -> MCAlifeGraphContentsCodable? {
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

    func uploadToFirebase() {
        guard let graphJSONData = convertIconsToJSON() else { return }
        let firData = try! FirebaseEncoder().encode(graphJSONData)
        var ref = Database.database().reference()
        guard let userIdentifier = Auth.auth().currentUser?.uid else {
            print("not logged in!")
            return
        }
        ref.child(userIdentifier).child("my first graph").setValue(firData)
        
//        self.ref = Database.database().reference()
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        self.ref.child(uid).child("Query Heart Rate Data").childByAutoId().setValue(hrData)

    }
}
