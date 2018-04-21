//
//  MCALifeGraphViewController.swift
//  Mass Class App
//
//  Created by Christian Flanders on 4/20/18.
//  Copyright © 2018 Origin Valley. All rights reserved.
//

import UIKit

class MCALifeGraphViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var testTextView: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dealWithPan(_:)))
        testTextView.addGestureRecognizer(panGestureRecognizer)
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(dealWithPinch(_:)))
        testTextView.addGestureRecognizer(pinchGestureRecognizer)
        
        let imageView = UIImageView(frame: contentView.frame)
        imageView.image = #imageLiteral(resourceName: "dots-polka-white-spots-blue-1920x1080-c2-ffffff-40e0d0-l2-15-34-a-315-f-3")
        contentView.addSubview(imageView)
        contentView.sendSubview(toBack: imageView)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard let frameToSet = UserDefaults.standard.data(forKey: "frame") else { return }
        guard let decoded = try? JSONDecoder().decode(CGRect.self, from: frameToSet) else { return }
        testTextView.frame = decoded

        
    }
    var contentOffset: CGFloat = 20
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.graphActionSequeIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MCALifeGraphSelectionViewController {
            controller.transitioningDelegate = slideInTransitioningDelegate
            controller.modalPresentationStyle = .custom
        }
    }
    @objc func dealWithPan(_ panGesture: UIPanGestureRecognizer) {
        if !(testTextView.frame.maxX < contentView.frame.maxX) {
            if panGesture.translation(in: contentView).x > 0 {
                return
            }
        }
        print("test is \(testTextView.frame.maxX)")
        print("view is \(contentView.frame.maxX)")
        let translation = panGesture.translation(in: self.view)
        testTextView.center.x = panGesture.location(in: contentView).x
        testTextView.center.y =  panGesture.location(in: contentView).y
        if panGesture.location(in: self.view).x > self.view.frame.size.width - 50   {
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x + contentOffset, y: 0), animated: true)
            contentOffset += 1
        }
        
        
    }

    @objc func dealWithPinch(_ sender: UIPinchGestureRecognizer) {
        print(sender.scale)
        testTextView.center = sender.location(in: contentView)
        testTextView.frame.size = CGSize(width: testTextView.frame.size.width * sender.scale, height: testTextView.frame.size.width * sender.scale)
        sender.scale = 1
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    
    func saveLocation() {
        guard let encoder = try? JSONEncoder().encode(testTextView.frame) else { return }
        let defaults  = UserDefaults.standard
        defaults.set(encoder, forKey: "frame")
        
        if let string = String(data: encoder, encoding: .utf8 ) {
            print(string)
        }
}


}
