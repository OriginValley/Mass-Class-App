//
//  MCALifeGraphIconNoteView.swift
//  Mass Class App
//
//  Created by Christian Flanders on 4/21/18.
//  Copyright © 2018 Origin Valley. All rights reserved.
//

import Foundation
import UIKit

class MCALifeGraphIconNoteView: MCALifeGraphIconBaseView, UITextViewDelegate {
    
    var textView: UITextView!
    
    convenience init(frame:CGRect, textToDisplay: String ) {
        self.init(frame: frame)
                
        guard let iconTextView = textView else { return }
        
        iconTextView.text = textToDisplay
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTextView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTextView()
    }
    
    
    private func addTextView() {
        textView = UITextView(frame: self.bounds)
        textView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        textView.isEditable = true
        textView.isSelectable = true
        textView.text = "Placeholder"
        textView.delegate = self
        textView.font = UIFont.init(name: "Avenir-Next", size: 13.0)
        textView.drawCornerRadius(8)
        self.addSubview(textView)
        self.bringSubview(toFront: textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
