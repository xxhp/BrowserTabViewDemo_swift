//
//  ViewController.swift
//  BrowserTabView_Swift
//
//  Created by xiaohaibo on 3/11/15.
//  Copyright (c) 2015 xiaohaibo. All rights reserved.
//

import UIKit

class ViewController: UIViewController,BrowserTabViewDelegate {
    
    @IBOutlet weak var label: UILabel!
    var tabController :BrowserTabView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        label.textColor = UIColor.whiteColor();
        tabController = BrowserTabView(titles:["Tab 1","Tab 2","Tab 3","Tab 4","Tab 5"] , delegate:self);
        self.view.addSubview(tabController!);
        var addButton :UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        addButton.setImage(UIImage(named:"tab_new_add.png")?, forState:UIControlState.Normal);
        addButton.addTarget(self, action: "add:", forControlEvents: UIControlEvents.TouchUpInside)
        addButton.frame = CGRectMake(1024-40, 5, 27 , 27);
        self.view.addSubview(addButton);
        
        self.view.backgroundColor = UIColor.darkGrayColor();
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func add(sender:UIButton){
        tabController?.addTab(title: "new Tab")
    }
    
    func browserTabViewDidRemoveTab(browserTabView abrowserTabView:BrowserTabView,atIndex index :Int){
        println("BrowserTabView Did Remove Tab at: \(index)");
    }
   
    func browserTabViewDidSelectedTab(browserTabView abrowserTabView:BrowserTabView,atIndex index :Int){
        println("BrowserTabView DidSelected Tab at: \(index)");
        label.text = "Selected Tab at: \(index)";
        
    }
}

