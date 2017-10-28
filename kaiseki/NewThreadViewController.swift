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


extension UIImage{
    
    func alpha(_ value:CGFloat)->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
}


class NewThreadViewController: UIViewController, UITextFieldDelegate {
    
    // FIREBASE DECLARATIONS
    
    var threadsRef: DatabaseReference!
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
    var btn_color_red: UIButton!
    var btn_color_green: UIButton!
    var btn_color_blue: UIButton!
    var btn_color_gray: UIButton!
    var btn_color_black: UIButton!
    var btn_color_white: UIButton!
    var colorPick: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SET FIREBASE DATA REF
        
        threadsRef = Database.database().reference().child("thread-items")
        
        
        // OVERLAY
        
        overlay = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        overlay.backgroundColor = UIColor.black
        overlay.alpha = 0
        self.view.addSubview(overlay)
        
        
        // CARD
        
        card = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 280))
        let card_origin_y = self.view.frame.height + 140
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
        btn_save.setTitle("Add Car", for: .normal)
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
        textField_a.addTarget(self, action: #selector(self.textFieldADidChange), for: UIControlEvents.editingChanged)
        card.addSubview(textField_a)
        
  
        
        // TEXTFIELD_B
        
        textField_b = UITextField(frame: CGRect(x: 10, y: 63, width: self.view.frame.width - 20, height: 32))
        textField_b.backgroundColor = UIColor.clear
        textField_b.textColor = UIColor.black
        textField_b.placeholder = "Make (e.g. Honda)"
        textField_b.delegate = self
        textField_b.font = .systemFont(ofSize: 16)
        textField_b.isUserInteractionEnabled = true
        textField_b.addTarget(self, action: #selector(self.textFieldBDidChange), for: UIControlEvents.editingChanged)
        card.addSubview(textField_b)
        

        
        // TEXTFIELD_C
        
        textField_c = UITextField(frame: CGRect(x: 10, y: 116, width: self.view.frame.width - 20, height: 32))
        textField_c.backgroundColor = UIColor.clear
        textField_c.textColor = UIColor.black
        textField_c.placeholder = "Model (e.g. Civic)"
        textField_c.delegate = self
        textField_c.font = .systemFont(ofSize: 16)
        textField_c.isUserInteractionEnabled = true
        textField_c.addTarget(self, action: #selector(self.textFieldCDidChange), for: UIControlEvents.editingChanged)
        card.addSubview(textField_c)
        
        
        // COLOR PICKER
        
        let colorImage = UIImage(named: "icon-check")
        colorPick =  "black"
        
        btn_color_black = UIButton(frame: CGRect(x: 8, y: 170, width: 30, height: 30))
        btn_color_black.backgroundColor = UIColor.black
        btn_color_black.setImage(colorImage?.alpha(1.0), for: UIControlState.normal)
        btn_color_black.layer.cornerRadius = 15
        btn_color_black.layer.borderWidth = 0
        btn_color_black.setTitle("", for: .normal)
        btn_color_black.addTarget(self, action: #selector(self.didTapColor), for: .touchUpInside)
        btn_color_black.alpha = 1.0
        btn_color_black.layer.borderWidth = 1
        btn_color_black.layer.borderColor = UIColor.ash(alpha: 0.3).cgColor
        card.addSubview(btn_color_black)
        
        btn_color_gray = UIButton(frame: CGRect(x: 46, y: 170, width: 30, height: 30))
        btn_color_gray.backgroundColor = UIColor.gray
        btn_color_gray.layer.cornerRadius = 15
        btn_color_gray.layer.borderWidth = 0
        btn_color_gray.setTitle("", for: .normal)
        btn_color_gray.addTarget(self, action: #selector(self.didTapColor), for: .touchUpInside)
        btn_color_gray.alpha = 1.0
        btn_color_gray.layer.borderWidth = 1
        btn_color_gray.layer.borderColor = UIColor.ash(alpha: 0.3).cgColor
        card.addSubview(btn_color_gray)
        
        btn_color_white = UIButton(frame: CGRect(x: 84, y: 170, width: 30, height: 30))
        btn_color_white.backgroundColor = UIColor.white
        btn_color_white.layer.cornerRadius = 15
        btn_color_white.layer.borderWidth = 0
        btn_color_white.setTitle("", for: .normal)
        btn_color_white.addTarget(self, action: #selector(self.didTapColor), for: .touchUpInside)
        btn_color_white.alpha = 1.0
        btn_color_white.layer.borderWidth = 1
        btn_color_white.layer.borderColor = UIColor.ash(alpha: 0.3).cgColor
        card.addSubview(btn_color_white)
        
        btn_color_red = UIButton(frame: CGRect(x: 122, y: 170, width: 30, height: 30))
        btn_color_red.backgroundColor = UIColor.cherry()
        btn_color_red.layer.cornerRadius = 15
        btn_color_red.layer.borderWidth = 0
        btn_color_red.setTitle("", for: .normal)
        btn_color_red.addTarget(self, action: #selector(self.didTapColor), for: .touchUpInside)
        btn_color_red.alpha = 1.0
        btn_color_red.layer.borderWidth = 1
        btn_color_red.layer.borderColor = UIColor.ash(alpha: 0.3).cgColor
        card.addSubview(btn_color_red)
        
        btn_color_blue = UIButton(frame: CGRect(x: 160, y: 170, width: 30, height: 30))
        btn_color_blue.backgroundColor = UIColor.blueberry()
        btn_color_blue.layer.cornerRadius = 15
        btn_color_blue.layer.borderWidth = 0
        btn_color_blue.setTitle("", for: .normal)
        btn_color_blue.addTarget(self, action: #selector(self.didTapColor), for: .touchUpInside)
        btn_color_blue.alpha = 1.0
        btn_color_blue.layer.borderWidth = 1
        btn_color_blue.layer.borderColor = UIColor.ash(alpha: 0.3).cgColor
        card.addSubview(btn_color_blue)
        
        btn_color_green = UIButton(frame: CGRect(x: 198, y: 170, width: 30, height: 30))
        btn_color_green.backgroundColor = UIColor.forest()
        btn_color_green.layer.cornerRadius = 15
        btn_color_green.layer.borderWidth = 0
        btn_color_green.setTitle("", for: .normal)
        btn_color_green.addTarget(self, action: #selector(self.didTapColor), for: .touchUpInside)
        btn_color_green.alpha = 1.0
        btn_color_green.layer.borderWidth = 1
        btn_color_green.layer.borderColor = UIColor.ash(alpha: 0.3).cgColor
        card.addSubview(btn_color_green)
        
        
        
        // KEYBOARD
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        // SETUP
        
        disableBtn()

        
    }
    
    // COLOR PICK
    
    @objc func didTapColor(sender:UIButton){
        clearAllColors()
        markColor(btn: sender)
        
    }
    
    
    func markColor(btn: UIButton){
        let colorImage = UIImage(named: "icon-check")
        let colorImageBlack = UIImage(named: "icon-check-black")
        if (btn == btn_color_black){
            btn.setImage(colorImage?.alpha(1.0), for: UIControlState.normal)
            self.colorPick = "black"
        }else if (btn == btn_color_gray){
            btn.setImage(colorImage?.alpha(1.0), for: UIControlState.normal)
            self.colorPick = "gray"
        }else if (btn == btn_color_white){
            btn.setImage(colorImageBlack?.alpha(1.0), for: UIControlState.normal)
            self.colorPick = "white"
        }else if (btn == btn_color_red){
            btn.setImage(colorImage?.alpha(1.0), for: UIControlState.normal)
            self.colorPick = "red"
        }else if (btn == btn_color_green){
            btn.setImage(colorImage?.alpha(1.0), for: UIControlState.normal)
            self.colorPick = "green"
        }else if (btn == btn_color_blue){
            btn.setImage(colorImage?.alpha(1.0), for: UIControlState.normal)
            self.colorPick = "blue"
        }
    }
    
    func clearAllColors(){
        let colorImage = UIImage(named: "icon-check")
        let colorImageBlack = UIImage(named: "icon-check-black")
        btn_color_black.setImage(colorImage?.alpha(0), for: UIControlState.normal)
        btn_color_gray.setImage(colorImage?.alpha(0), for: UIControlState.normal)
        btn_color_white.setImage(colorImageBlack?.alpha(0), for: UIControlState.normal)
        btn_color_red.setImage(colorImage?.alpha(0), for: UIControlState.normal)
        btn_color_green.setImage(colorImage?.alpha(0), for: UIControlState.normal)
        btn_color_blue.setImage(colorImage?.alpha(0), for: UIControlState.normal)

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
    
    
    // TEXTFIELD BEHAVIOR
    
    @objc func textFieldADidChange(_ textField: UITextField) {
        checkInput()
    }
    @objc func textFieldBDidChange(_ textField: UITextField) {
        checkInput()
    }
    @objc func textFieldCDidChange(_ textField: UITextField) {
        checkInput()
    }
    
    
    func checkInput(){
        if textField_a.hasText {
            if textField_b.hasText {
                if textField_c.hasText {
                    enableBtn()
                }else {
                    disableBtn()
                }
            }else {
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
        self.textField_c.endEditing(true)
        
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
        self.textField_c.endEditing(true)
        
        if let threadPrimaryContent = textField_c.text, let threadSecondaryContent = textField_a.text, let threadTertiaryContent = textField_b.text, let quaternaryContent = self.colorPick {
            let thread = Thread(primaryContent: threadPrimaryContent, secondaryContent: threadSecondaryContent, tertiaryContent: threadTertiaryContent, quaternaryContent: quaternaryContent, addedByUser: (Auth.auth().currentUser?.email)!)
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
