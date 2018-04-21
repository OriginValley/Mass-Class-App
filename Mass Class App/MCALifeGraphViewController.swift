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
    var contentOffset: CGFloat = 20
    
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
//            contentOffset += 1
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



}
