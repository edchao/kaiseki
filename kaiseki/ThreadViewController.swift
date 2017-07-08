//
//  ThreadViewController.swift
//  kaiseki
//
//  Created by Ed Chao on 4/16/17.
//  Copyright © 2017 Ed Chao. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class ThreadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // DATA TAGS
    
    var dataTitle : String?
    var dataMeta : String?
   
    // TITLE and SECTION LABEL
    
    var titleView = CarTitleView()
    
    
    // TABLE
    
    var table_thread: UITableView! = UITableView()
    let screenSize: CGRect = UIScreen.main.bounds
    
    
    // USER EDUCATION
    
    var halo: UIImageView!
    

    // GRADIENT MASK
    
    var gradientMask: UIView!

    // BUTTONS
    
    let btnPost = UIButton()
    
    // FIREBASE DECLARATIONS
    
    var postsRef:FIRDatabaseReference!
    var posts = [Post]()
    
    // PASSED DATA FROM HOME
    
    var threadKey:String!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        // SET FIREBASE DATA REF
        
        postsRef = FIRDatabase.database().reference().child("post-items")
        startObservingDB()
        

        // VIEW COLOR
        
        view.backgroundColor = UIColor.ink(alpha: 1.0)
        

        
        // INITIALIZE BUTTON
        
        let postImage = UIImage(named: "btn-compose")
        let btnPostImage = UIButton(type: .custom)
        btnPostImage.setImage(postImage, for: UIControlState.normal)

        
        btnPost.frame = CGRect(x:20, y:50, width:30, height:30)
        btnPost.setTitleColor(UIColor.black, for: UIControlState.normal)
        btnPost.setImage(postImage, for: UIControlState.normal)
        btnPost.addTarget(self, action: #selector(self.newPost), for: .touchUpInside)
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: btnPost), animated: true);
        
        // CHANGE NAVIGATION BAR COLOR

        self.navigationController?.navigationBar.backgroundColor = UIColor.ink(alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.topItem?.title = "";
        
        let backImage = UIImage(named: "btn-back")
        self.navigationController?.navigationBar.backIndicatorImage = backImage


        
        // SETUP TABLE
        
        table_thread.frame = CGRect(x:0, y:0, width: screenSize.width, height: screenSize.height);
        table_thread.rowHeight = UITableViewAutomaticDimension
        table_thread.estimatedRowHeight = 350
        table_thread.delegate = self
        table_thread.dataSource = self
        table_thread.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
//        table_thread.separatorColor = UIColor.coal(alpha: 1.0)
        table_thread.separatorStyle = .none
        table_thread.contentInset = UIEdgeInsets(top: 166, left: 0, bottom: 0, right: 0)
        table_thread.tableHeaderView = UIView(frame: CGRect(x:0, y:0, width:screenSize.width, height:11))
        table_thread.backgroundColor = UIColor.ink(alpha: 1.0)
        self.view.addSubview(table_thread)
        self.table_thread.rowHeight = UITableViewAutomaticDimension
        
        
        
        // GRADIENT MASK
        
        let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height

        
        gradientMask = UIView(frame: CGRect(x: 0, y: navigationBarHeight + statusBarHeight, width: screenSize.width, height: 30))
        let gradient = CAGradientLayer()
        
        gradient.frame = gradientMask.bounds
        gradient.colors = [UIColor.ink(alpha: 1.0).cgColor, UIColor.ink(alpha: 0).cgColor]
        
        gradientMask.layer.insertSublayer(gradient, at: 0)
        self.view.addSubview(gradientMask)

    

        // INITIALIZE TITLEVIEW
        
        titleView = CarTitleView(frame: CGRect(x:0, y:-166, width:screenSize.width, height:166))
//        titleView.titleLabel.text = self.navigationItem.title
        self.table_thread.addSubview(titleView)
        
        
        // NUX
        
        halo = UIImageView(frame: CGRect(x: 0, y: 0, width: 320.0 , height: 320.0))
        halo.image = UIImage(named: "halo")
        halo.center.x = screenSize.width - 30
        halo.center.y = 24
        halo.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        halo.alpha = 0
        self.navigationController?.navigationBar.addSubview(halo)

        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        if dataTitle != nil {
            self.titleView.titleLabel.text = dataTitle
        }
        
        if dataMeta != nil {
            self.titleView.metaLabel.text = dataMeta

        }
    }

    
    
    // READ FROM FIREBASE DATABASE
    
    func startObservingDB() {
        
        postsRef.queryOrdered(byChild: "addedToThread").queryStarting(atValue: threadKey).queryEnding(atValue: threadKey).observe(FIRDataEventType.value, with: { (snapshot: FIRDataSnapshot) in
            var newPosts = [Post]()
            
            for post in snapshot.children {
                let postObject = Post(snapshot: post as! FIRDataSnapshot)
                newPosts.append(postObject)
            }
            
            self.posts = newPosts.reversed()
            self.table_thread.reloadData()
            self.checkNUX()
        }) { (error: Error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    // NUX
    
    
    func checkNUX(){
        if posts.count == 0 {
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
    
    
    
    // POST BUTTON
    
    func newPost(sender: AnyObject){
        let newPostVC: NewPostViewController = NewPostViewController(nibName: nil, bundle: nil)
        self.definesPresentationContext = true
        newPostVC.modalPresentationStyle = UIModalPresentationStyle.custom
        newPostVC.transitioningDelegate = self as? UIViewControllerTransitioningDelegate
        
        // PASS DATA
        newPostVC.threadKey = self.threadKey

        
        self.present(newPostVC, animated: false) { () -> Void in
            //
        }
    }
    
    
//    func composePost(sender:AnyObject){
//        print("Trying to Post")
//        
//        let postAlert = UIAlertController(title: "Your post", message: "Enter your post", preferredStyle: .alert)
//        postAlert.addTextField { (textField:UITextField) in
//            textField.placeholder = "Your mileage"
//        }
//        postAlert.addTextField { (textField:UITextField) in
//            textField.placeholder = "Your post"
//        }
//        
//        
//        postAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action:UIAlertAction) in
//            if let mileageContent = postAlert.textFields?.first?.text, let postContent = postAlert.textFields?.last?.text{
//                
//                // CREATE A UNIQUE ID FOR THIS POST
//                let postRef = self.postsRef.childByAutoId()
//                
//                // CREATE THE POST WITH ALL THE THINGS NEEDED
//                let post = Post(mileage: mileageContent, timestamp: FIRServerValue.timestamp(), content: postContent, addedByUser: (FIRAuth.auth()?.currentUser?.email)!, addedToThread:self.threadKey as String)
//                
//                // CONVERT THE POST TO DICTIONARY
//                postRef.setValue(post.toAny())
//                
//            }
//        }))
//        
//        
//        self.present(postAlert, animated: true, completion:nil)
//    }
    
    
    // TABLE FUNCTIONS
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! PostTableViewCell
        
        let mileageNumber = Int(post.mileage)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:mileageNumber!))
        
        
        let timestamp = post.timestamp
        let date = timestamp as! Int
        let converted = NSDate(timeIntervalSince1970: TimeInterval(date / 1000))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateStyle = DateFormatter.Style.medium
        let dateString = dateFormatter.string(from: converted as Date)

        
        cell.mileageLabel.text = formattedNumber
        cell.dateLabel.text = dateString
        cell.contentLabel.text = post.content
        cell.contentView.layoutMargins = UIEdgeInsets.zero // HACK to remove native cell padding
//        cell.backgroundColor = UIColor.ink(alpha: 1.0) // HACK to get the gap before the separator colored ink

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let post = posts[indexPath.row]
            post.itemRef?.removeValue()
        }
    }

    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
