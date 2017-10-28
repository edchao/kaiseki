//
//  NewPostViewController.swift
//  kaiseki
//
//  Created by Ed Chao on 6/13/17.
//  Copyright © 2017 Ed Chao. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class NewPostViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    // FIREBASE DECLARATIONS
    
    var postsRef:DatabaseReference!
    var posts = [Post]()
    
    // PASSED DATA FROM HOME
    
    var threadKey:String!
    
    
    // VARS
    
    let screenSize: CGRect = UIScreen.main.bounds
    var card_origin_y : CGFloat! = 300
    
    
    // ELEMENTS
    
    var textField_a : UITextField!
    var textField_b : UITextView!
    var label_note : UILabel!

    
    var overlay: UIView!
    var card: UIView!
    
    var btn_cancel: UIButton!
    var btn_save: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SET FIREBASE DATA REF
        
        postsRef = Database.database().reference().child("post-items")
        
        
        // OVERLAY
        
        overlay = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        overlay.backgroundColor = UIColor.black
        overlay.alpha = 0
        self.view.addSubview(overlay)
        
        
        // CARD
        
        card = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 280))
        let card_origin_y = self.view.frame.height + 90
        card.center.y = card_origin_y
        card.backgroundColor = UIColor.chalk()
        card.layer.shadowOffset = CGSize(width: 0, height: 0)
        card.layer.shadowOpacity = 0.0
        card.layer.shadowRadius = 10.0
        self.view.addSubview(card)
        
        
        
        // BUTTONS
        btn_cancel = UIButton(frame: CGRect(x:0, y: 30, width: self.view.frame.width/2, height: 64))
        btn_cancel.center.y = card.frame.height - (64/2)
        btn_cancel.backgroundColor = UIColor.grape()
        btn_cancel.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn_cancel.layer.cornerRadius = 0
        btn_cancel.layer.borderWidth = 0
        btn_cancel.alpha = 0
        btn_cancel.setTitle("Cancel", for: .normal)
        btn_cancel.addTarget(self, action: #selector(self.didTapCancel), for: .touchUpInside)
        card.addSubview(btn_cancel)
        
        
        
        btn_save = UIButton(frame: CGRect(x: self.view.frame.width/2, y: 30, width: self.view.frame.width/2, height: 64))
        btn_save.center.y = card.frame.height - (64/2)
        btn_save.backgroundColor = UIColor.mint(1.0)
        btn_save.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn_save.layer.cornerRadius = 0
        btn_save.layer.borderWidth = 0
        btn_save.setTitle("Add Note", for: .normal)
        btn_save.addTarget(self, action: #selector(self.didTapSave), for: .touchUpInside)
        btn_save.alpha = 1.0
        card.addSubview(btn_save)
        
        
        
        // textField_a
        
        textField_a = UITextField(frame: CGRect(x: 10, y: 10, width: self.view.frame.width - 20, height: 32))
        textField_a.backgroundColor = UIColor.clear
        textField_a.textColor = UIColor.black
        textField_a.placeholder = "Mileage (e.g. 1000)"
        textField_a.delegate = self
        textField_a.font = .systemFont(ofSize: 16)
        textField_a.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        textField_a.isUserInteractionEnabled = true
        card.addSubview(textField_a)
        
        
        
        // textField_b
        
        textField_b = UITextView(frame: CGRect(x: 7, y: 63, width: self.view.frame.width - 20, height: 32))
        textField_b.backgroundColor = UIColor.clear
        textField_b.textColor = UIColor.ink()
        textField_b.delegate = self
        textField_b.font = .systemFont(ofSize: 16)
        textField_b.isUserInteractionEnabled = true
        card.addSubview(textField_b)
        
        
        // label for textField_b
        
        label_note = UILabel(frame: CGRect(x: 4, y: 4, width: view.frame.width, height: 30))
        label_note.font = label_note.font.withSize(16)
        label_note.textColor = UIColor.placeHolderColor()
        label_note.text = "Write something (e.g. oil change)"
        label_note.numberOfLines = 0
        textField_b.addSubview(label_note)
        
        
        
        
        // KEYBOARD
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        // OTHER SETUP
        
        disableBtn()
        
        
    }
    
    
    // VIEW BEHAVIOR
    
    
    override func viewDidAppear(_ animated: Bool) {
        textField_a.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions(rawValue: UInt(UIViewAnimationCurve.easeInOut.rawValue)), animations: {
            self.overlay.alpha = 1.0
            self.btn_cancel.alpha = 1.0
        }, completion: nil)
        
    }
    
    // KEYBOARD BEHAVIOR
    
    @objc func keyboardWillShow(notification: NSNotification!) {
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
    
    
    @objc func keyboardWillHide(notification: NSNotification!) {
        var userInfo = notification.userInfo!
        let durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        let animationDuration = durationValue.doubleValue
        let curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        let animationCurve = curveValue.intValue
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: UIViewAnimationOptions(rawValue: UInt(animationCurve << 16)), animations: {
            self.card.layer.shadowOpacity = 0
            self.card.backgroundColor = UIColor.white
            self.card.center.y = self.card_origin_y
        }, completion: nil)
    }
    
    
    
    // TEXTVIEW and TEXTFIELD BEHAVIOR
    
    
    func textViewDidChange(_ textView: UITextView) {
        if textField_b.hasText {
            self.label_note.isHidden = true
            checkInput()
        } else {
            self.label_note.isHidden = false
            checkInput()
        }
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkInput()
    }
    
    
    
    func checkInput(){
        if textField_a.hasText {
            if textField_b.hasText {
                enableBtn()
            }
            else {
                disableBtn()
            }
        } else {
            disableBtn()
        }
    }
    
    
    func disableBtn(){
        self.btn_save.alpha = 0.3
        self.btn_save.isEnabled = false
    }
    
    func enableBtn(){
        self.btn_save.alpha = 1
        self.btn_save.isEnabled = true
    }
    
    
    
    
    // BUTTON ACTIONS
    
    @objc func didTapCancel(sender:UIButton){
        self.textField_a.endEditing(true)
        self.textField_b.endEditing(true)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions(rawValue: UInt(UIViewAnimationCurve.easeInOut.rawValue)), animations: {
            self.btn_cancel.alpha = 0
            self.overlay.alpha = 0
            self.card.layer.shadowOpacity = 0
            self.card.backgroundColor = UIColor.white
            self.card.center.y = self.screenSize.height + (280/2)
        }, completion: nil)
        
        delay(delay: 0.25){
            self.dismiss(animated: false, completion: { () -> Void in
                //
            })
        }
        
    }
    
    
    @objc func didTapSave(sender:UIButton){
        self.textField_a.endEditing(true)
        self.textField_b.endEditing(true)
        
        if let postPrimaryContent = textField_a.text, let postSecondaryContent = textField_b.text {
            
            // CREATE A UNIQUE ID FOR THIS POST
            let postRef = self.postsRef.childByAutoId()
            
            // CREATE THE POST WITH ALL THE THINGS NEEDED
            let post = Post(mileage: postPrimaryContent, timestamp: ServerValue.timestamp(), content: postSecondaryContent, addedByUser: (Auth.auth().currentUser?.email)!, addedToThread:self.threadKey as String)
            
            // CONVERT THE POST TO DICTIONARY
            postRef.setValue(post.toAny())

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
