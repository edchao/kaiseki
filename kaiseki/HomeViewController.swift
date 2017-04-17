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
    
    let btn1 = UIButton()
    let btn2 = UIButton()
    
    // CAROUSEL DECLARATIONS
    
    var carousel = iCarousel()
    var numbers = [Int]()
    
    
    // FIREBASE DECLARATIONS
    
    var postsRef:FIRDatabaseReference!
    var threadsRef: FIRDatabaseReference!
    var posts = [Post]()
    var threads = [Thread]()
    
    

    // VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // SET FIREBASE DATA REF
        
        postsRef = FIRDatabase.database().reference().child("post-items")
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
        
        btn1.frame = CGRect(x:20, y:50, width:80, height:30)
        btn1.setTitleColor(UIColor.black, for: UIControlState.normal)
        btn1.setTitle("Post", for: UIControlState.normal)
        btn1.addTarget(self, action: #selector(self.composePost), for: .touchUpInside)
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: btn1), animated: true);
        
        btn2.frame = CGRect(x:100, y:50, width:80, height:30)
        btn2.setTitleColor(UIColor.black, for: UIControlState.normal)
        btn2.setTitle("Thread", for: UIControlState.normal)
        btn2.addTarget(self, action: #selector(self.createThread), for: .touchUpInside)
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: btn2), animated: true);
        

    }

    
    // READ FROM FIREBASE DATABASE
    
    
    func startObservingDB() {
        
        postsRef.observe(FIRDataEventType.value, with: { (snapshot: FIRDataSnapshot) in
            var newPosts = [Post]()
            
            for post in snapshot.children {
                let postObject = Post(snapshot: post as! FIRDataSnapshot)
                newPosts.append(postObject)
            }
            
            self.posts = newPosts
            self.carousel.reloadData()
            
        }) { (error: Error) in
            print(error.localizedDescription)
        }
        
    }
    
    // POST BUTTON
    
    func composePost(sender:AnyObject){
        print("Trying to Post")
        
        let postAlert = UIAlertController(title: "Your post", message: "Enter your post", preferredStyle: .alert)
        postAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Your post"
        }
        
        postAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action:UIAlertAction) in
            if let postContent = postAlert.textFields?.first?.text{
                let post = Post(content: postContent, addedByUser: (FIRAuth.auth()?.currentUser?.email)!)
                let postRef = self.postsRef.child(postContent.lowercased())
                postRef.setValue(post.toAny())
            }
        }))
        
        
        self.present(postAlert, animated: true, completion:nil)
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
                let threadRef = self.threadsRef.child(threadContent.lowercased())
                threadRef.setValue(thread.toAny())
            }
        }))
        
        
        self.present(threadAlert, animated: true, completion:nil)
    }

    
    
    // CAROUSEL FUNCTIONS
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return posts.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let tempView = CoverView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        let post = posts[index]
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        button.backgroundColor = UIColor.clear
        button.tag = index
        button.addTarget(self, action: #selector(self.goToThread), for: .touchUpInside)
        tempView.addSubview(button)
        tempView.titleLabel.text = post.content
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
        vc.title = posts[sender.tag].content
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
