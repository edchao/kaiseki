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


class HomeViewController: UIViewController, iCarouselDelegate, iCarouselDataSource {
    
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
        
        
        
        // INITIALIZE CAROUSEL
        
        numbers = [1,2,3,4,5,6]
        
        carousel = iCarousel(frame: CGRect(x:0, y:0, width:200, height:200))
        carousel.center = view.center
        carousel.dataSource = self as iCarouselDataSource
        carousel.delegate = self as iCarouselDelegate
        
        
        self.view.addSubview(carousel)
        
        
        // INITIALIZE BUTTON
        
 
        btnThread.frame = CGRect(x:100, y:50, width:80, height:30)
        btnThread.setTitleColor(UIColor.black, for: UIControlState.normal)
        btnThread.setTitle("Thread", for: UIControlState.normal)
        btnThread.addTarget(self, action: #selector(self.createThread), for: .touchUpInside)
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: btnThread), animated: true);
        

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
    
    func createThread(sender:AnyObject){
        print("Trying to Create Thread")
        
        let threadAlert = UIAlertController(title: "Your thread", message: "Enter your thread name", preferredStyle: .alert)
        threadAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Your thread name"
        }
        
        threadAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action:UIAlertAction) in
            if let threadContent = threadAlert.textFields?.first?.text{
                let thread = Thread(content: threadContent, addedByUser: (FIRAuth.auth()?.currentUser?.email)!)
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
        let tempView = CoverView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        let thread = threads[index]
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        button.backgroundColor = UIColor.clear
        button.tag = index
        button.addTarget(self, action: #selector(self.goToThread), for: .touchUpInside)
        tempView.addSubview(button)
        tempView.titleLabel.text = thread.content
        return tempView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            return value * 1.2
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
        vc.title = threads[sender.tag].content
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
