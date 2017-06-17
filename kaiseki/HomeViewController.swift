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
}



class HomeViewController: UIViewController, iCarouselDelegate, iCarouselDataSource, UIViewControllerTransitioningDelegate {
    
    
    // VARS
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    
    // TITLE and SECTION LABEL
    
    var titleView = TitleView()
    var sectionView = SectionView()
    
    // BUTTONS
    
    let btnThread = UIButton()
    
    
    // FIREBASE DECLARATIONS
    
    var threadsRef: FIRDatabaseReference!
    var threads = [Thread]()
    
    
    // CAROUSEL DECLARATIONS
    
    var carousel = iCarousel()
    var numbers = [Int]()
    
    

    // VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // SET FIREBASE DATA REF
        
        threadsRef = FIRDatabase.database().reference().child("thread-items")
        startObservingDB()
        
        
        // SET VIEW COLOR
        
        self.view.backgroundColor = UIColor.ink(alpha: 1.0)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true        
        
        
        // INITIALIZE CAROUSEL
        
        numbers = [1,2,3,4,5,6]
        
        carousel = iCarousel(frame: CGRect(x:40, y:290, width:screenSize.width, height:240))
        carousel.dataSource = self as iCarouselDataSource
        carousel.delegate = self as iCarouselDelegate
        carousel.contentOffset = CGSize(width: -100.0, height: 0)
        
        
        self.view.addSubview(carousel)
        
        
        // INITIALIZE BUTTON
        
 
        btnThread.frame = CGRect(x:100, y:50, width:80, height:30)
        btnThread.setTitleColor(UIColor.white, for: UIControlState.normal)
        btnThread.setTitle("Add Car", for: UIControlState.normal)
        btnThread.addTarget(self, action: #selector(self.newThread), for: .touchUpInside)
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: btnThread), animated: true);
        

        // INITIALIZE TITLEVIEW
        
        titleView = TitleView(frame: CGRect(x:0, y:120, width:screenSize.width, height:80))
        titleView.titleLabel.text = "Cars"
        self.view.addSubview(titleView)
        
        // INITIALIZE SECTIONVIEW
        
        sectionView = SectionView(frame: CGRect(x:0, y:230, width:screenSize.width, height: 40))
        sectionView.sectionLabel.text = "My Cars".uppercased()
        self.view.addSubview(sectionView)
        
    }

    
    // READ FROM FIREBASE DATABASE
    
    
    func startObservingDB() {
        
        threadsRef.observe(FIRDataEventType.value, with: { (snapshot: FIRDataSnapshot) in
            var newThreads = [Thread]()
            
            for thread in snapshot.children {
                let threadObject = Thread(snapshot: thread as! FIRDataSnapshot)
                newThreads.append(threadObject)
            }
            
            self.threads = newThreads
            self.carousel.reloadData()
            
        }) { (error: Error) in
            print(error.localizedDescription)
        }
        
    }
    


    
    // THREAD BUTTON
    
    func newThread(sender: AnyObject){
        let newThreadVC: NewThreadViewController = NewThreadViewController(nibName: nil, bundle: nil)
        self.definesPresentationContext = true
        newThreadVC.modalPresentationStyle = UIModalPresentationStyle.custom
        newThreadVC.transitioningDelegate = self as? UIViewControllerTransitioningDelegate
        self.present(newThreadVC, animated: false) { () -> Void in
            //
        }
    }
    
    func createThread(sender:AnyObject){
        print("Trying to Create Thread")
        
        let threadAlert = UIAlertController(title: "Add a Car", message: "Enter your car information", preferredStyle: .alert)
        threadAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Year (e.g. 2000)"
        }
        threadAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Model (e.g. Honda)"
        }
        threadAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Make (e.g. Civic)"
        }
        
        threadAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action:UIAlertAction) in
            //
        }))
        
        threadAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action:UIAlertAction) in
            if let threadPrimaryContent = threadAlert.textFields?[2].text, let threadSecondaryContent = threadAlert.textFields?[0].text, let threadTertiaryContent = threadAlert.textFields?[1].text {
                let thread = Thread(primaryContent: threadPrimaryContent, secondaryContent: threadSecondaryContent, tertiaryContent: threadTertiaryContent, addedByUser: (FIRAuth.auth()?.currentUser?.email)!)
                let threadRef = self.threadsRef.childByAutoId()
                threadRef.setValue(thread.toAny())
            }
        }))
        
        
        
        
        self.present(threadAlert, animated: true, completion:nil)
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
        vc.title = threads[sender.tag].primaryContent
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
