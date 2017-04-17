//
//  CoverView.swift
//  kaiseki
//
//  Created by Ed Chao on 4/15/17.
//  Copyright © 2017 Ed Chao. All rights reserved.
//

import UIKit

class CoverView: UIView {

    private var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var boxView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 2
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowOpacity = 0.15
        self.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        self.layer.shadowRadius = 20.0
        
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        backgroundColor = .white
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
    
  }
