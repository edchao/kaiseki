//
//  NewThreadViewController.swift
//  kaiseki
//
//  Created by Ed Chao on 6/13/17.
//  Copyright © 2017 Ed Chao. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class NewThreadViewController: UIViewController, UITextFieldDelegate {
    
    // FIREBASE DECLARATIONS
    
    var threadsRef: FIRDatabaseReference!
    var threads = [Thread]()
    
    
    // VARS
    
    let screenSize: CGRect = UIScreen.main.bounds
    var card_origin_y : CGFloat! = 300

    
    // ELEMENTS
    
    var textField_a : UITextField!
    var textField_b : UITextField!
    var textField_c : UITextField!

    var overlay: UIView!
    var card: UIView!

    var btn_cancel: UIButton!
    var btn_save: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SET FIREBASE DATA REF
        
        threadsRef = FIRDatabase.database().reference().child("thread-items")
        
        
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
        
        
        
        // BUTTONS
        btn_cancel = UIButton(frame: CGRect(x:0, y: 20, width: 64, height: 60))
        btn_cancel.backgroundColor = UIColor.blue
        btn_cancel.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn_cancel.layer.cornerRadius = 4
        btn_cancel.layer.borderWidth = 1
        btn_cancel.setTitle("Cancel", for: .normal)
        btn_cancel.addTarget(self, action: #selector(self.didTapCancel), for: .touchUpInside)
        self.view.addSubview(btn_cancel)
        
        
        btn_save = UIButton(frame: CGRect(x: 0, y: 30, width: self.view.frame.width, height: 64))
        btn_save.center.y = card.frame.height - (64/2)
        btn_save.backgroundColor = UIColor.blue
        btn_save.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn_save.layer.cornerRadius = 0
        btn_save.layer.borderWidth = 0
        btn_save.setTitle("Save", for: .normal)
        btn_save.addTarget(self, action: #selector(self.didTapSave), for: .touchUpInside)
        btn_save.alpha = 1.0
        card.addSubview(btn_save)
        

        
        // textField_a
        
        textField_a = UITextField(frame: CGRect(x: 10, y: 10, width: self.view.frame.width - 20, height: 32))
        textField_a.backgroundColor = UIColor.clear
        textField_a.textColor = UIColor.black
        textField_a.placeholder = "Year (e.g. 2000)"
        textField_a.delegate = self
        textField_a.font = .systemFont(ofSize: 16)
        textField_a.isUserInteractionEnabled = true
        card.addSubview(textField_a)
        
  
        
        // TEXTFIELD_B
        
        textField_b = UITextField(frame: CGRect(x: 10, y: 63, width: self.view.frame.width - 20, height: 32))
        textField_b.backgroundColor = UIColor.clear
        textField_b.textColor = UIColor.black
        textField_b.placeholder = "Make (e.g. Honda)"
        textField_b.delegate = self
        textField_b.font = .systemFont(ofSize: 16)
        textField_b.isUserInteractionEnabled = true
        card.addSubview(textField_b)
        

        
        // TEXTFIELD_C
        
        textField_c = UITextField(frame: CGRect(x: 10, y: 116, width: self.view.frame.width - 20, height: 32))
        textField_c.backgroundColor = UIColor.clear
        textField_c.textColor = UIColor.black
        textField_c.placeholder = "Model (e.g. Civic)"
        textField_c.delegate = self
        textField_c.font = .systemFont(ofSize: 16)
        textField_c.isUserInteractionEnabled = true
        card.addSubview(textField_c)
        
        
        // KEYBOARD
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        
        
    }
    
    
    // VIEW BEHAVIOR
    
    
    override func viewDidAppear(_ animated: Bool) {
        textField_a.becomeFirstResponder()

        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions(rawValue: UInt(UIViewAnimationCurve.easeInOut.rawValue)), animations: {
            self.overlay.alpha = 1.0
        }, completion: nil)
    
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
            self.overlay.alpha = 1.0
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
    
    

    
    
    // BUTTON ACTIONS
    
    func didTapCancel(sender:UIButton){
        self.textField_a.endEditing(true)
        self.textField_b.endEditing(true)
        self.textField_c.endEditing(true)

        delay(delay: 0.5){
            self.dismiss(animated: false, completion: { () -> Void in
                //
            })
        }
        
    }
    
    
    func didTapSave(sender:UIButton){
        self.textField_a.endEditing(true)
        self.textField_b.endEditing(true)
        self.textField_c.endEditing(true)
        
        if let threadPrimaryContent = textField_c.text, let threadSecondaryContent = textField_a.text, let threadTertiaryContent = textField_b.text {
            let thread = Thread(primaryContent: threadPrimaryContent, secondaryContent: threadSecondaryContent, tertiaryContent: threadTertiaryContent, addedByUser: (FIRAuth.auth()?.currentUser?.email)!)
            let threadRef = self.threadsRef.childByAutoId()
            threadRef.setValue(thread.toAny())
        }

        
        delay(delay: 0.5){
            self.dismiss(animated: false, completion: { () -> Void in
                //
            })
        }
        
    }
    
    
    // ETC

    public func delay(delay: Double, closure:@escaping (() -> Void)) {
        
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when) {
            closure()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
