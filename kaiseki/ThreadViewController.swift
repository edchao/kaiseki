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
    
    // TABLE
    
    var table_thread: UITableView! = UITableView()
    let screenSize: CGRect = UIScreen.main.bounds



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
        
        view.backgroundColor = UIColor.white
        
        
        // INITIALIZE BUTTON
        
        btnPost.frame = CGRect(x:20, y:50, width:80, height:30)
        btnPost.setTitleColor(UIColor.black, for: UIControlState.normal)
        btnPost.setTitle("Post", for: UIControlState.normal)
        btnPost.addTarget(self, action: #selector(self.composePost), for: .touchUpInside)
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: btnPost), animated: true);
        
        
        // SETUP TABLE
        
        table_thread.frame = CGRect(x:0, y:0, width: screenSize.width, height: screenSize.height);
        table_thread.rowHeight = UITableViewAutomaticDimension
        table_thread.estimatedRowHeight = 350
        table_thread.delegate = self
        table_thread.dataSource = self
        table_thread.register(UINib(nibName: "ThreadTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        table_thread.separatorInset = UIEdgeInsetsMake(15, 15, 15, 15)
        table_thread.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        table_thread.tableHeaderView = UIView(frame: CGRect(x:0, y:0, width:screenSize.width, height:11))
        table_thread.backgroundColor = UIColor.clear
        self.view.addSubview(table_thread)
        self.table_thread.rowHeight = UITableViewAutomaticDimension
    

        
    }

    

    
    // READ FROM FIREBASE DATABASE
    
    func startObservingDB() {
        
        postsRef.queryOrdered(byChild: "addedToThread").queryStarting(atValue: threadKey).queryEnding(atValue: threadKey).observe(FIRDataEventType.value, with: { (snapshot: FIRDataSnapshot) in
            var newPosts = [Post]()
            
            for post in snapshot.children {
                let postObject = Post(snapshot: post as! FIRDataSnapshot)
                newPosts.append(postObject)
            }
            
            self.posts = newPosts
            self.table_thread.reloadData()
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
                
                // CREATE A UNIQUE ID FOR THIS POST
                let postRef = self.postsRef.childByAutoId()
                
                // CREATE THE POST WITH ALL THE THINGS NEEDED
                let post = Post(content: postContent, addedByUser: (FIRAuth.auth()?.currentUser?.email)!, addedToThread:self.threadKey as String)
                
                // CONVERT THE POST TO DICTIONARY
                postRef.setValue(post.toAny())
                
            }
        }))
        
        
        self.present(postAlert, animated: true, completion:nil)
    }
    
    
    // TABLE FUNCTIONS
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! ThreadTableViewCell
        cell.contentLabel.text = post.content
        
        
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
