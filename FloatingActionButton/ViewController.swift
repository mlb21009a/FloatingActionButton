//
//  ViewController.swift
//  FloatingActionButton
//
//  Created by R on 2017/04/26.
//  Copyright © 2017年 マック太郎. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var fab: FloatingActionButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fab.addElement(title: "あいうえお", image: #imageLiteral(resourceName: "Image")) {
            
        }
        
        fab.addElement(title: "かきくけこ", image: #imageLiteral(resourceName: "Image")) {
            
        }
        fab.addElement(title: "さしすせそ", image: #imageLiteral(resourceName: "Image")) {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

