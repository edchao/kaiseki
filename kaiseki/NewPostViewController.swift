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


class NewPostViewController: UIViewController {

    var label_compose : UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // LABEL
        label_compose = UILabel(frame: CGRect(x: 20, y: 10, width: self.view.frame.width, height: 30))
        label_compose.textColor = UIColor.coal()
        label_compose.text = "Write something..."
        label_compose.numberOfLines = 2
        self.view.addSubview(label_compose)
    
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
