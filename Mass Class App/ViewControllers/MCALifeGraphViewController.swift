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

enum LifeGraphOptions: String {
    case past = "past"
    case present = "present"
    case future = "future"
}

class MCALifeGraphViewController: UIViewController, UITextViewDelegate, ShouldDeleteIcon {

    @IBOutlet weak var testTextView: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    private let backgroundLightColor = UIColor(red: 227/255, green: 239/255, blue: 243/255, alpha: 1.0)
    private let backgroundDarkColor = UIColor(red: 20/255, green: 58/255, blue: 82/255, alpha: 1)
    
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()

    private let firebaseViewManager = MCALifeGraphFirebaseManager()
    
    private var timer: Timer!
    
    var loadedGraph: LifeGraphOptions!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       checkForSavedBackgroundColor()
        
        checkForViewsFromFIR()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        firebaseViewManager.contentView = contentView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        firebaseViewManager.uploadContentToFirebase(for: loadedGraph)
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
    
    func loadGraphFor(_ graphPeriod: LifeGraphOptions) {
        
    }
    
    func checkForSavedBackgroundColor() {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "shouldBeDarkBackgroundColor") {
            self.contentView.backgroundColor = backgroundDarkColor
        } else {
            self.contentView.backgroundColor = backgroundLightColor
        }
    }
    
    func switchBackgroundColor() {
        let defaults = UserDefaults.standard
        let shouldBeDark = defaults.bool(forKey: "shouldBeDarkBackgroundColor")
        if shouldBeDark {
            defaults.set(false, forKey: "shouldBeDarkBackgroundColor")
            self.contentView.backgroundColor = backgroundLightColor
        } else {
            defaults.set(true, forKey: "shouldBeDarkBackgroundColor")
            self.contentView.backgroundColor = backgroundDarkColor
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
        newIcon.shouldDeleteDelegate = self
        checkViewForCollisions(view: newIcon)
        contentView.addSubview(newIcon)
        contentView.bringSubview(toFront: newIcon)
        firebaseViewManager.uploadContentToFirebase(for: self.loadedGraph)

    }
    
    func addNoteIcon() {
        let newIconOrigin = CGPoint(x: scrollView.frame.midX, y: scrollView.frame.midY)
        let newIconFrame = CGRect(origin: newIconOrigin, size: Constants.graphIconDefaultSize)
        let newIcon = MCALifeGraphIconNoteView(frame: newIconFrame)
        newIcon.contentView = contentView
        newIcon.scrollView = scrollView
        newIcon.shouldDeleteDelegate = self

        checkViewForCollisions(view: newIcon)
        contentView.addSubview(newIcon)
        contentView.bringSubview(toFront: newIcon)
        firebaseViewManager.uploadContentToFirebase(for: self.loadedGraph)

    }
    
    func addImageIcon(image: UIImage) {
        let newIconOrigin = CGPoint(x: scrollView.frame.midX, y: scrollView.frame.midY)
        let newIconFrame = CGRect(origin: newIconOrigin, size: Constants.graphIconDefaultSize)
        let newIcon = MCALifeImageIconView(frame: newIconFrame, image: image)
        newIcon.contentView = contentView
        newIcon.scrollView = scrollView
        newIcon.shouldDeleteDelegate = self
        checkViewForCollisions(view: newIcon)
        contentView.addSubview(newIcon)
        contentView.bringSubview(toFront: newIcon)
        firebaseViewManager.uploadContentToFirebase(for: self.loadedGraph)

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
        
    fileprivate func checkForViewsFromFIR() {
        DispatchQueue.global(qos: .userInitiated).async {
            // Download file or perform expensive task
            self.firebaseViewManager.decodeViewsFromFirebase(for: self.loadedGraph, completion: { (contents) in
                print("this gets called")
                if contents != nil {
                    let viewsToAdd = self.firebaseViewManager.convertModelToViews(contents!)
                    DispatchQueue.main.async {
                        // Update the UI
                        for views in viewsToAdd {
                            views.contentView = self.contentView
                            views.scrollView = self.scrollView
                            views.shouldDeleteDelegate = self
                            self.contentView.bringSubview(toFront: views)
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
            self.firebaseViewManager.uploadContentToFirebase(for: self.loadedGraph)
        })
    }
    
    func deleteIcon(_ icon: MCALifeGraphIconBaseView) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete Icon", style: .destructive) { (action) in
            icon.removeFromSuperview()
            self.firebaseViewManager.uploadContentToFirebase(for: self.loadedGraph)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}

