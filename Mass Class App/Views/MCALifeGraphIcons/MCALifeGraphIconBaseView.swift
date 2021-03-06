//
//  MCALifeGraphIconBaseView.swift
//  Mass Class App
//
//  Created by Christian Flanders on 4/21/18.
//  Copyright © 2018 Origin Valley. All rights reserved.
//

import UIKit

class MCALifeGraphIconBaseView: UIView{

    var contentView: UIView! = nil
    var scrollView: UIScrollView! = nil
    
    var contentOffset: CGFloat = 20
    
    var identifier: String?
    
    var shouldDeleteDelegate: ShouldDeleteIcon! = nil
    
    func randomIdentifier(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }

    
    fileprivate func setRandomBackgroundColor() {
        let randomOne = CGFloat(arc4random_uniform(UInt32(255)))
        let randomTwo = CGFloat(arc4random_uniform(UInt32(255)))
        let randomThree = CGFloat(arc4random_uniform(UInt32(255)))
        let randomColor = UIColor.init(red: randomOne / 255,  green: randomTwo / 255, blue: randomThree / 255 , alpha: 1)

        self.backgroundColor = randomColor
    }
    
    
    convenience init(frame: CGRect, bgColor: UIColor, identifier: String) {
        self.init(frame: frame)
        
//        self.backgroundColor = bgColor
        self.identifier = identifier
        self.drawCornerRadius(8)
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpGestures()
        self.identifier = randomIdentifier()
        self.backgroundColor = UIColor.white
        //        setRandomBackgroundColor()
        self.drawCornerRadius(8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpGestures()
        self.identifier = randomIdentifier()
        self.backgroundColor = UIColor.white
//        setRandomBackgroundColor()
        self.drawCornerRadius(8)

    }
    
    private func setUpGestures() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dealWithPan(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(dealWithPinch(_:)))
        self.addGestureRecognizer(pinchGestureRecognizer)
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(dealWithLongPress(_:)))
        longPressGestureRecognizer.minimumPressDuration = 1.5
        self.addGestureRecognizer(longPressGestureRecognizer)
        
    }
    
    var shouldDrawShadow = false {
        willSet {
            if newValue && shouldDrawShadow == true {
                return
            } else if newValue && !shouldDrawShadow {
                drawShadow()
            } else if !newValue {
                removeShadow()
            }
        }
    }
    
    @objc func dealWithLongPress(_ longPress: UILongPressGestureRecognizer) {
        print("longpressed")
        shouldDeleteDelegate.deleteIcon(self)
        
        
    }
    
    @objc func dealWithPan(_ panGesture: UIPanGestureRecognizer) {
       shouldDrawShadow = true
        contentView.bringSubview(toFront: self)
        let location = panGesture.location(in: contentView)
//        print("pan gesture location = \(location)")
        
        if panGesture.state == .ended {
            shouldDrawShadow = false
        }
        
        
        let viewGoingOutOfContentView = self.frame.maxX <= contentView.frame.maxX
        
        // If the user tries to drag the view past the right edge of the canvas
        
        if self.frame.maxX >= contentView.frame.maxX - 20 && panGesture.translation(in: contentView).x > 0   {
//            print("OVER")
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
               self.center.x = self.contentView.frame.maxX - (self.frame.width / 2 ) - 20
            }) { (finished) in
                
            }
            return
        }
        
        // If the user tries to drag the view past the left edge of the canvas
        if self.frame.minX <= contentView.frame.minY + 20 && panGesture.translation(in: contentView).x < 0 {
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.center.x = self.contentView.frame.minX + (self.frame.width / 2 ) + 20
            }) { (finished) in
                
            }
            return
        }
        
        // If the user tries to drag the view past the top edge of the canvas
//        print(self.frame.minY)
//        print(contentView.frame.minY)
        
        if panGesture.location(in: contentView).y < 20 {
//            print("ayyy")
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.center.y = self.contentView.frame.minY + (self.frame.height / 2 ) + 20
            }) { (finished) in
                
            }
            return
        }
        
        // Check if the user is trying to drag the view past the bottom edge of the canvas
        
        if panGesture.location(in: contentView).y > contentView.frame.maxY - 20 {
//            print("ayyy")
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.center.y = self.contentView.frame.maxY - (self.frame.height / 2 ) - 20
            }) { (finished) in
                
            }
            return
        }

        
        self.center.x = panGesture.location(in: contentView).x
        self.center.y =  panGesture.location(in: contentView).y
        if panGesture.location(in: self).x > self.frame.size.width - 50   {
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x + contentOffset, y: 0), animated: true)
            contentOffset += 1
        }
        
        
    }
    
    @objc func dealWithPinch(_ sender: UIPinchGestureRecognizer) {
        contentView.bringSubview(toFront: self)
//        print(sender.scale)
        self.center = sender.location(in: contentView)
        self.frame.size = CGSize(width: self.frame.size.width * sender.scale, height: self.frame.size.width * sender.scale)
        sender.scale = 1
    }
    
}
