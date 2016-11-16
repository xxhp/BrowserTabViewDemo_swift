//
//  ViewController.swift
//  BrowserTabView_Swift
//
//  Created by xiaohaibo on 3/11/15.
//  Copyright (c) 2015 xiaohaibo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    var tabController :BrowserTabView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        label.textColor = UIColor.white;
        tabController = BrowserTabView(titles:["Tab 1","Tab 2","Tab 3","Tab 4","Tab 5"] , delegate:self);
        self.view.addSubview(tabController!);
        let addButton :UIButton = UIButton(type:UIButtonType.custom) as UIButton
        addButton.setImage(UIImage(named:"tab_new_add.png"), for:UIControlState());
        addButton.addTarget(self, action: #selector(ViewController.add(_:)), for: UIControlEvents.touchUpInside)
        addButton.frame = CGRect(x: 1024-40, y: 5, width: 27 , height: 27);
        self.view.addSubview(addButton);
        
        self.view.backgroundColor = UIColor.darkGray;
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func add(_ sender:UIButton){
        tabController?.addTab(title: "new Tab")
    }
    
}

extension ViewController:BrowserTabViewDelegate{


    func browserTabViewDidRemoveTab(browserTabView abrowserTabView:BrowserTabView,atIndex index :Int){
        print("BrowserTabView Did Remove Tab at: \(index)");
    }
    
    func browserTabViewDidSelectedTab(browserTabView abrowserTabView:BrowserTabView,atIndex index :Int){
        print("BrowserTabView DidSelected Tab at: \(index)");
        label.text = "Selected Tab at: \(index)";
        
    }

}

