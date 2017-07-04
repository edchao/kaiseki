//
//  AuthViewController.swift
//  kaiseki
//
//  Created by Ed Chao on 7/4/17.
//  Copyright © 2017 Ed Chao. All rights reserved.
//

import UIKit
import Firebase



class AuthViewController: UIViewController, UITextFieldDelegate {

    // VARS
    
    let screenSize: CGRect = UIScreen.main.bounds
    var btn_signup: UIButton!
    var btn_login: UIButton!
    var btn_choose_signup: UIButton!
    var btn_choose_login: UIButton!
    var textfield_email: UITextField!
    var textfield_password: UITextField!
    var stroke_a: UIView!
    var stroke_b: UIView!
    var card:UIView!
    var card_origin_y:CGFloat!
    var choice:String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // INIT
        
        choice = ""
        
        // SET VIEW COLOR
        
        self.view.backgroundColor = UIColor.ink(alpha: 1.0)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        // SET CARD
        
        card_origin_y = screenSize.height - 300/2 - 30

        
        card = UIView(frame: CGRect(x: 0, y: 0, width: 240, height: 300))
        card.center.y = card_origin_y
        card.center.x = screenSize.width / 2
        card.backgroundColor = UIColor.ink()
        card.layer.shadowOffset = CGSize(width: 0, height: 0)
        card.layer.shadowOpacity = 0.0
        card.layer.shadowRadius = 10.0
        self.view.addSubview(card)

        

        
        // SET TEXTFIELDS
                
        textfield_email = UITextField(frame: CGRect(x: 0, y: 0, width: self.card.frame.width - 20, height: 48))
        textfield_email.backgroundColor = UIColor.clear
        textfield_email.textColor = UIColor.white
        textfield_email.placeholder = "Email"
        textfield_email.attributedPlaceholder = NSAttributedString(string: textfield_email.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.coal()])
        textfield_email.delegate = self
        textfield_email.font = .systemFont(ofSize: 16)
        textfield_email.addTarget(self, action: #selector(self.textFieldEmailDidChange), for: UIControlEvents.editingChanged)
        textfield_email.isUserInteractionEnabled = true
        textfield_email.alpha = 0
        textfield_email.isEnabled = false
        
        self.card.addSubview(textfield_email)
        
        textfield_password = UITextField(frame: CGRect(x: 0, y: 58, width: self.card.frame.width - 20, height: 48))
        textfield_password.backgroundColor = UIColor.clear
        textfield_password.placeholder = "Password"
        textfield_password.attributedPlaceholder = NSAttributedString(string: textfield_password.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.coal()])
        textfield_password.textColor = UIColor.white
        textfield_password.delegate = self
        textfield_password.font = .systemFont(ofSize: 16)
        textfield_password.addTarget(self, action: #selector(self.textFieldPWDidChange), for: UIControlEvents.editingChanged)
        textfield_password.isUserInteractionEnabled = true
        textfield_password.alpha = 0
        textfield_email.isEnabled = false
        self.card.addSubview(textfield_password)
        
        
        stroke_a = UIView(frame: CGRect(x: 0, y: 48, width: self.card.frame.width, height: 1))
        stroke_a.backgroundColor = UIColor.ash()
        stroke_a.alpha = 0
        self.card.addSubview(stroke_a)
        
        stroke_b = UIView(frame: CGRect(x: 0, y: 48 + 48 + 10, width: self.card.frame.width, height: 1))
        stroke_b.backgroundColor = UIColor.ash()
        stroke_b.alpha = 0
        self.card.addSubview(stroke_b)


        
        // SET BUTTONS
    
        
        btn_choose_signup = UIButton(frame: CGRect(x:0, y: 136, width: self.card.frame.width, height: 60))
        btn_choose_signup.backgroundColor = UIColor.mint(1.0)
        btn_choose_signup.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn_choose_signup.layer.cornerRadius = 4
        btn_choose_signup.layer.borderWidth = 0
        btn_choose_signup.setTitle("SIGNUP", for: .normal)
        btn_choose_signup.addTarget(self, action: #selector(self.didTapChooseSignup), for: .touchUpInside)
        btn_choose_signup.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)

        self.card.addSubview(btn_choose_signup)
        
        
        btn_choose_login = UIButton(frame: CGRect(x:0, y: 206, width: self.card.frame.width, height: 60))
        btn_choose_login.backgroundColor = UIColor.ash(alpha: 1.0)
        btn_choose_login.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn_choose_login.layer.cornerRadius = 4
        btn_choose_login.layer.borderWidth = 0
        btn_choose_login.setTitle("LOGIN", for: .normal)
        btn_choose_login.addTarget(self, action: #selector(self.didTapChooseLogin), for: .touchUpInside)
        btn_choose_login.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        self.card.addSubview(btn_choose_login)
        
        
        btn_signup = UIButton(frame: CGRect(x:0, y: 136, width: self.card.frame.width, height: 60))
        btn_signup.backgroundColor = UIColor.mint(1.0)
        btn_signup.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn_signup.layer.cornerRadius = 4
        btn_signup.layer.borderWidth = 0
        btn_signup.setTitle("SIGNUP", for: .normal)
        btn_signup.addTarget(self, action: #selector(self.didTapSignup), for: .touchUpInside)
        btn_signup.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn_signup.alpha = 0
        btn_signup.isEnabled = false
        self.card.addSubview(btn_signup)
        
        
        
        btn_login = UIButton(frame: CGRect(x:0, y: 136, width: self.card.frame.width, height: 60))
        btn_login.backgroundColor = UIColor.mint(1.0)
        btn_login.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn_login.layer.cornerRadius = 4
        btn_login.layer.borderWidth = 0
        btn_login.setTitle("LOGIN", for: .normal)
        btn_login.addTarget(self, action: #selector(self.didTapLogin), for: .touchUpInside)
        btn_login.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn_login.alpha = 0
        btn_login.isEnabled = false
        self.card.addSubview(btn_login)
        
        
        
        // KEYBOARD
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        

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
            self.card.center.y = self.screenSize.height - kbSize.height - self.card.frame.height/2
            self.btn_choose_signup.alpha = 0
            self.btn_choose_login.alpha = 0
            self.btn_choose_signup.isEnabled = false
            self.btn_choose_login.isEnabled = false
            self.textfield_email.alpha = 1
            self.textfield_password.alpha = 1
            self.stroke_a.alpha = 1
            self.stroke_b.alpha = 1
            
            if self.choice == "login" {
                self.btn_login.alpha = 1
                self.btn_login.isEnabled = true
            }else {
                self.btn_signup.alpha = 1
                self.btn_signup.isEnabled = true
            }
            
            

        }, completion: nil)
    }
    
    
    func keyboardWillHide(notification: NSNotification!) {
        var userInfo = notification.userInfo!
        let durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        let animationDuration = durationValue.doubleValue
        let curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        let animationCurve = curveValue.intValue
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: UIViewAnimationOptions(rawValue: UInt(animationCurve << 16)), animations: {
            self.card.center.y = self.card_origin_y
            self.btn_choose_signup.alpha = 1
            self.btn_choose_login.alpha = 1
            self.btn_choose_signup.isEnabled = true
            self.btn_choose_login.isEnabled = true
            self.textfield_email.alpha = 0
            self.textfield_password.alpha = 0
            self.stroke_a.alpha = 0
            self.stroke_b.alpha = 0
            self.btn_login.alpha = 0
            self.btn_login.isEnabled = false
            self.btn_signup.alpha = 0
            self.btn_signup.isEnabled = false



        }, completion: nil)
    }

    // TEXTFIELD BEHAVIOR
    
    func textFieldEmailDidChange(_ textField: UITextField) {
        checkInput()
        
        
    }
    func textFieldPWDidChange(_ textField: UITextField) {
        checkInput()
        
        
    }
    
    func checkInput(){
        if textfield_email.hasText {
            if textfield_password.hasText {
                //
            }
            else {
                //
            }
        } else {
            //
        }
    }

    
    
    // BUTTON FUNCTIONS
    
    
    func didTapChooseLogin (sender: UIButton){
        
        self.choice = "login"
        self.textfield_email.isEnabled = true
        self.textfield_password.isEnabled = true
        self.textfield_email.becomeFirstResponder()

    
    }
    
    func didTapChooseSignup (sender: UIButton){
        self.choice = "signup"
        self.textfield_email.isEnabled = true
        self.textfield_password.isEnabled = true
        self.textfield_email.becomeFirstResponder()
    }
    
    
    func didTapSignup (sender: UIButton){
        authSignup(email: self.textfield_email.text!, password: self.textfield_password.text!)
    }
    
    
    func didTapLogin (sender: UIButton){
        authLogin(email: self.textfield_email.text!, password: self.textfield_password.text!)
    }
    
    
    // AUTH LOGIN FUNCTION
    
    func authLogin(email: String, password: String){
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user:FIRUser?, error:Error?) in
            if error == nil {
                print(user?.email ?? "This is the user email")
                let vc = HomeViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                print("you are trying to login with" + password)
                print(error?.localizedDescription ?? "this is the error localized description")
            }
        })
    }
    
    // AUTH SIGN UP FUNCTION
    
    func authSignup(email: String, password: String){

        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user:FIRUser?, error:Error?) in
            if error == nil {
                self.authLogin(email: email, password: password)
            }else{
                print(error?.localizedDescription ?? "this is the error localized description")
            }
        })
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
