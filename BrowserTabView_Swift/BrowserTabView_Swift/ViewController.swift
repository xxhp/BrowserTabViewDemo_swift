//
//  ViewController.swift
//  BrowserTabView_Swift
//
//  Created by xiaohaibo on 3/11/15.
//  Copyright (c) 2015 xiaohaibo. All rights reserved.
//

import UIKit

class ViewController: UIViewController,BrowserTabViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        tabController= [[BrowserTabView alloc] initWithTabTitles:[NSArray arrayWithObjects:@"Tab 1",@"Tab 2",@"Tab 3", nil]
//            andDelegate:self];
        var tabController : BrowserTabView  = BrowserTabView(Titles:["1","2"] , Delegate:self);
        self.view.addSubview(tabController);
         self.view.backgroundColor = UIColor.darkGrayColor();
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func  finished() {
        return;
    }

}

