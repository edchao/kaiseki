//
//  NewThreadViewController.swift
//  kaiseki
//
//  Created by Ed Chao on 6/13/17.
//  Copyright © 2017 Ed Chao. All rights reserved.
//

import UIKit

class NewThreadViewController: UIViewController {
    
    // VARS
    
    let screenSize: CGRect = UIScreen.main.bounds
    var card_origin_y : CGFloat! = 300

    
    // ELEMENTS
    
    var label_compose: UILabel!
    var overlay: UIView!
    var textView_compose : UITextView!
    var card: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // OVERLAY
        
        overlay = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        overlay.backgroundColor = UIColor.black
        overlay.alpha = 0
        self.view.addSubview(overlay)
        
        
        // CARD
        
        card = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 280))
        let card_origin_y = self.view.frame.height + 90
        card.center.y = card_origin_y
        card.backgroundColor = UIColor.white
        card.layer.shadowOffset = CGSize(width: 0, height: 0)
        card.layer.shadowOpacity = 0.0
        card.layer.shadowRadius = 10.0
        self.view.addSubview(card)
        
        // TEXTFIELD
        
        textView_compose = UITextView(frame: CGRect(x: 15, y: 10, width: self.view.frame.width - 20, height: 220))
        textView_compose.backgroundColor = UIColor.clear
        textView_compose.textColor = UIColor.black
        textView_compose.isEditable = true
        textView_compose.isUserInteractionEnabled = true
        card.addSubview(textView_compose)
        
        
        // LABEL
        
        label_compose = UILabel(frame: CGRect(x: 20, y: 10, width: self.view.frame.width, height: 30))
        label_compose.textColor = UIColor.coal()
        label_compose.text = "Write something..."
        label_compose.numberOfLines = 2
        card.addSubview(label_compose)
        
        
        // KEYBOARD
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        textView_compose.becomeFirstResponder()
    }
    
    // KEYBOARD BEHAVIOR
    
    func keyboardWillShow(notification: NSNotification!) {
        var userInfo = notification.userInfo!
        let kbSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        let animationDuration = durationValue.doubleValue
        let curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        let animationCurve = curveValue.intValue
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: UIViewAnimationOptions(rawValue: UInt(animationCurve << 16)), animations: {
            self.overlay.alpha = 0.06
            self.card.backgroundColor = UIColor.white
            self.card.layer.shadowOpacity = 0.3
            self.card.center.y = self.screenSize.height - kbSize.height - self.card.frame.height/2
        }, completion: nil)
    }

    
    func keyboardWillHide(notification: NSNotification!) {
        var userInfo = notification.userInfo!
        let durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        let animationDuration = durationValue.doubleValue
        let curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        let animationCurve = curveValue.intValue
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: UIViewAnimationOptions(rawValue: UInt(animationCurve << 16)), animations: {
            self.overlay.alpha = 0
            self.card.layer.shadowOpacity = 0
            self.card.backgroundColor = UIColor.white
            self.card.center.y = self.card_origin_y
        }, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
