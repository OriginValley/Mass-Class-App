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

    let firebaseViewManager = MCALifeGraphFirebaseManager()
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: contentView.frame)
        imageView.image = #imageLiteral(resourceName: "dots-polka-white-spots-blue-1920x1080-c2-ffffff-40e0d0-l2-15-34-a-315-f-3")
        contentView.addSubview(imageView)
        contentView.sendSubview(toBack: imageView)
        
        checkForViewsFromFIR()

    }
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        firebaseViewManager.contentView = contentView
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        firebaseViewManager.uploadContentToFirebase()
        timer.invalidate()
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
        firebaseViewManager.uploadContentToFirebase()

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
        firebaseViewManager.uploadContentToFirebase()

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
        firebaseViewManager.uploadContentToFirebase()

    }
    
    @IBAction func unwindToGraph(segue:UIStoryboardSegue) {}

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
    
    // TODO: This should be one function, not calling two
    
    fileprivate func checkForViewsFromFIR() {
        DispatchQueue.global(qos: .userInitiated).async {
            // Download file or perform expensive task
            self.firebaseViewManager.decodeViewsFromFirebase(completion: { (contents) in
                print("this gets called")
                if contents != nil {
                    let viewsToAdd = self.firebaseViewManager.convertModelToViews(contents!)
                    DispatchQueue.main.async {
                        // Update the UI
                        for views in viewsToAdd {
                            views.contentView = self.contentView
                            views.scrollView = self.scrollView
                            self.contentView.addSubview(views)
                        }
                        self.startAutoSaveTimer()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.startAutoSaveTimer()
                    }
                }
            })
        }
    }
    
    func startAutoSaveTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (_) in
            print("uploading")
            self.firebaseViewManager.uploadContentToFirebase()
        })
        
    }
    


}
