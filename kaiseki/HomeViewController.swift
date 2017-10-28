//
//  HomeViewController.swift
//  kaiseki
//
//  Created by Ed Chao on 4/1/17.
//  Copyright © 2017 Ed Chao. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

extension UIColor {
    class func ink(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: alpha)
    }
    class func coal(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: alpha)
    }
    class func graphite(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: alpha)
    }
    class func ash(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: 177/255, green: 177/255, blue: 177/255, alpha: alpha)
    }
    class func cherry(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: 205/255, green: 0/255, blue: 0/255, alpha: alpha)
    }
    class func mint(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: 76/255, green: 198/255, blue: 147/255, alpha: alpha)
    }
    class func forest(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: 0/255, green: 138/255, blue: 59/255, alpha: alpha)
    }
    class func chalk(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: alpha)
    }
    class func grape(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: 101/255, green: 91/255, blue: 200/255, alpha: alpha)
    }
    class func blueberry(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: 11/255, green: 83/255, blue: 167/255, alpha: alpha)
    }
    
}

extension UIColor {
    
    class func placeHolderColor() -> UIColor {
        return UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)
    }
    
}

class HomeViewController: UIViewController, iCarouselDelegate, iCarouselDataSource, UIViewControllerTransitioningDelegate {
    
    
    // VARS
    
    let screenSize: CGRect = UIScreen.main.bounds
    let stdPadding: CGFloat = 24.0
    
    
    // TITLE and SECTION LABEL
    
    var titleView = TitleView()
    var sectionView = SectionView()
    
    // BUTTONS
    
    let btn_thread = UIButton()
    let btn_logout = UIButton()
    
    
    // FIREBASE DECLARATIONS
    
    var threadsRef: DatabaseReference!
    var threads = [Thread]()
    var user: User!
    let usersRef = Database.database().reference(withPath: "online")

    
    
    // CAROUSEL DECLARATIONS
    
    var carousel = iCarousel()
    var numbers = [Int]()
    
    
    // USER EDUCATION
    
    var halo: UIImageView!
    

    // VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // SET FIREBASE DATA REF
        
        threadsRef = Database.database().reference().child("thread-items")
        startObservingDB()
        
        
        // SET VIEW COLOR
        
        self.view.backgroundColor = UIColor.ink(alpha: 1.0)
        self.navigationController?.navigationBar.backgroundColor = UIColor.ink(alpha: 0)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true        
        
        
        // INITIALIZE CAROUSEL
        
        numbers = [1,2,3,4,5,6]
        
        carousel = iCarousel(frame: CGRect(x:0, y:290, width:screenSize.width, height:240))
        carousel.dataSource = self as iCarouselDataSource
        carousel.delegate = self as iCarouselDelegate
        carousel.contentOffset = CGSize(width: -1 * (screenSize.width/2 - (180/2) - stdPadding
), height: 0)
        
        
        self.view.addSubview(carousel)
        
        
        // INITIALIZE BUTTON
        
        let threadImage = UIImage(named: "btn-add-car")
 
        btn_thread.frame = CGRect(x:100, y:50, width:40, height:26)
        btn_thread.setTitleColor(UIColor.white, for: UIControlState.normal)
//        btn_thread.setTitle("Add Car", for: UIControlState.normal)
        btn_thread.setImage(threadImage, for: UIControlState.normal)
        btn_thread.addTarget(self, action: #selector(self.newThread), for: .touchUpInside)
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: btn_thread), animated: true);
        
        btn_logout.frame = CGRect(x:0, y:0, width:60, height:26)
        btn_logout.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn_logout.setTitle("Logout", for: UIControlState.normal)
        btn_logout.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: btn_logout), animated: true);
        

        
        
        // INITIALIZE TITLEVIEW
        
        titleView = TitleView(frame: CGRect(x:0, y:120, width:screenSize.width, height:80))
        titleView.titleLabel.text = "Cars"
        self.view.addSubview(titleView)
        
        // INITIALIZE SECTIONVIEW
        
        sectionView = SectionView(frame: CGRect(x:0, y:230, width:screenSize.width, height: 40))
        sectionView.sectionLabel.text = "My Cars".uppercased()
        self.view.addSubview(sectionView)
        
        
        // NUX
        
        halo = UIImageView(frame: CGRect(x: 0, y: 0, width: 320.0 , height: 320.0))
        halo.image = UIImage(named: "halo")
        halo.center.x = screenSize.width - 30
        halo.center.y = 24
        halo.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        halo.alpha = 0
        self.view.addSubview(halo)
        
        
        // CHECK IF USER STATE HAS CHANGED or LOGGED OUT
        
//        Auth.auth().addStateDidChangeListener { auth, user in
//            if let _user = user {
//                self.user = User(uid: String, email: <#T##String#>)
//            } else {
//                let userRef = self.usersRef.child(self.user.uid)
//                userRef.removeValue()
//            }
//        }
        
    
    }
    
    
    
    // NUX
    
    
    func checkNUX(){
        print(threads.count)
        if threads.count == 0 {
            animateHalo()
        }else{
            rescindHalo()
        }
    }

    // ANIMATE HALO
    
    func animateHalo(){

        UIView.animate(withDuration: 1.0, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.halo.alpha = 1.0
            self.halo.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    
    func rescindHalo(){
        
        UIView.animate(withDuration: 1.0, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.halo.alpha = 0
            self.halo.transform = CGAffineTransform(scaleX: 0 , y: 0)
        }, completion: nil)
    }
    
    
    
    
    // READ FROM FIREBASE DATABASE
    
    
    func startObservingDB() {
    
        
        threadsRef.queryOrdered(byChild: "addedByUser").queryStarting(atValue: Auth.auth().currentUser?.email).queryEnding(atValue: Auth.auth().currentUser?.email).observe(DataEventType.value, with: { (snapshot: DataSnapshot) in
            var newThreads = [Thread]()
            
            for thread in snapshot.children {
                let threadObject = Thread(snapshot: thread as! DataSnapshot)
                newThreads.append(threadObject)
            }
            
            self.threads = newThreads
            self.carousel.reloadData()
            self.checkNUX()
        }) { (error: Error) in
            print(error.localizedDescription)
        }

        
        
    }
    

    // LOGOUT BUTTON
    
    
    func logout(_ sender: AnyObject) {
        do {
            let userRef = self.usersRef.child(self.user.uid)
            userRef.removeValue()
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    
    // THREAD BUTTON
    
    func newThread(sender: AnyObject){
        let newThreadVC: NewThreadViewController = NewThreadViewController(nibName: nil, bundle: nil)
        self.definesPresentationContext = true
        newThreadVC.modalPresentationStyle = UIModalPresentationStyle.custom
        newThreadVC.transitioningDelegate = self as UIViewControllerTransitioningDelegate
        self.present(newThreadVC, animated: false) { () -> Void in
            //
        }
    }
    


    
    
    // CAROUSEL FUNCTIONS
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return threads.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let tempView = CoverView(frame: CGRect(x: 0, y: 0, width: 180, height: 240))
        
        let thread = threads[index]
        
        print(thread)
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        button.backgroundColor = UIColor.clear
        button.tag = index
        button.addTarget(self, action: #selector(self.goToThread), for: .touchUpInside)
        tempView.addSubview(button)
        tempView.metaLabel.text = thread.secondaryContent + " " + thread.tertiaryContent.uppercased()
        tempView.titleLabel.text = thread.primaryContent
        
        // SET COLOR
        if (thread.quaternaryContent == "black"){
            tempView.backgroundColor = UIColor.coal()
        }else if(thread.quaternaryContent == "gray"){
            tempView.backgroundColor = UIColor.graphite()
        }else if(thread.quaternaryContent == "white"){
            tempView.backgroundColor = UIColor.chalk()
            tempView.titleLabel.textColor = UIColor.ink()
            tempView.metaLabel.textColor = UIColor.ink()
        }else if(thread.quaternaryContent == "red"){
            tempView.backgroundColor = UIColor.cherry()
        }else if(thread.quaternaryContent == "blue"){
            tempView.backgroundColor = UIColor.blueberry()
        }else if(thread.quaternaryContent == "green"){
            tempView.backgroundColor = UIColor.forest()
        }

        return tempView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            return value * 1.1
        }
        else if option == iCarouselOption.tilt {
            return value * 0.5
        }
        return value
    }
    
    
    // CAROUSEL TRAVERSAL
    
    func goToThread(sender:UIButton!)
    {
        print("Thread tapped")
        
        let vc = ThreadViewController()
        
        // PASS DATA
        vc.dataTitle = threads[sender.tag].primaryContent
        vc.dataMeta = threads[sender.tag].secondaryContent + " " + threads[sender.tag].tertiaryContent.uppercased()
        vc.threadKey = threads[sender.tag].key
        
        self.navigationController?.pushViewController(vc, animated: true)
        
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
