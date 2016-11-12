//
//  BrowserTabView.swift
//  BrowserTabView_Swift
//
//  Created by xiaohaibo on 3/11/15.
//  Copyright (c) 2015 xiaohaibo. All rights reserved.
//
//  github:https://github.com/xxhp/BrowserTabViewDemo_swift
//  Email:xiao_hb@qq.com

//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

import UIKit
@objc  protocol BrowserTabViewDelegate : NSObjectProtocol {
    @objc optional func browserTabViewDidRemoveTab(browserTabView abrowserTabView:BrowserTabView,atIndex index :Int)
    @objc optional func browserTabViewDidSelectedTab(browserTabView abrowserTabView:BrowserTabView,atIndex index :Int)
    
}
let TAB_FOOTER_HEIGHT:CGFloat = 5
let TAB_WIDTH:CGFloat = 154
let TAB_VIEW_FRAME:CGRect = CGRect(x: 0, y: 0, width: 1024, height: 44)
let TAB_OVERLAP_WIDTH:CGFloat = 15

class BrowserTabView: UIView {
    weak var delegate:BrowserTabViewDelegate?
    var tabWidth:CGFloat = TAB_WIDTH
    var tabFrameArray = NSMutableArray()
    var backgroundImage:UIImage?
    var tabArray = NSMutableArray()
    var selectedTabIndex :Int = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 242.0/255, green: 242.0/255, blue: 242.0/255, alpha: 1)
        backgroundImage = UIImage(named:"tab_background")
    }
    convenience init(titles aTitles: Array<String>, delegate aDelegate:BrowserTabViewDelegate) {
        self.init(frame:TAB_VIEW_FRAME)
        self.delegate = aDelegate
        for (i, title) in aTitles.enumerated(){
            let tab:BrowserTab? = BrowserTab(browserTabView: self)
            
            tab?.titleField?.text = title
            tab?.index = i
            self.tabArray.add(tab!)
        }
        
        self.tabWidth = self.bounds.size.width/CGFloat(self.tabArray.count+1)
        caculateFrame()
        
        if (self.tabArray.count>0) {
            selectTab(atIndex:0, animated:false)
        }
        
        
    }
    override func draw(_ rect:CGRect) {
        let height : CGFloat = self.bounds.size.height
        
        //left 5 dp to show the background, and give a look that tab has footer
        
        backgroundImage?.drawAsPattern(in: CGRect(x: 0, y: 0, width: self.frame.size.width, height: height - TAB_FOOTER_HEIGHT))
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func caculateFrame(){
        
       
        let height:CGFloat = self.bounds.height
        var right:CGFloat = 0
        
        tabFrameArray.removeAllObjects()
        
        for _ in stride(from: 0, to: self.tabArray.count, by: 1) {
            let tabFrame:CGRect = CGRect(x: right, y: 0, width: self.tabWidth, height: height - TAB_FOOTER_HEIGHT)
            tabFrameArray.add(NSValue(cgRect:tabFrame))
            right += (self.tabWidth - TAB_OVERLAP_WIDTH)
        }
        
        
    }
    
    func selectTab(atIndex index:Int, animated animation:Bool){
        
        selectedTabIndex = index
        
        delegate?.browserTabViewDidSelectedTab?(browserTabView: self, atIndex: index)
        //tabs before the selected are added in a sequence from the first to the selected
         for  i in stride(from: 0, to: selectedTabIndex, by: 1) {
            
            let tabFrameValue:NSValue = tabFrameArray[i] as! NSValue
            let tabFrame:CGRect = tabFrameValue.cgRectValue
            let tab :BrowserTab = tabArray[i] as! BrowserTab
            if (animation) {
                
                UIView.animate(withDuration: 0.15, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    tab.frame = tabFrame
                    tab.browserTabView = self
                    tab.selected = false
                    
                    }, completion: nil)
            }
            else{
                tab.frame = tabFrame
                tab.browserTabView = self
                tab.selected = false
                
            }
            addSubview(tab)
            
        }
        
        //tabs after the selected are added in a sequence from the last to the selected
        for i in stride(from: tabArray.count - 1, to: selectedTabIndex-1, by: -1)  {
            let tab :BrowserTab = tabArray[i] as! BrowserTab
            if (self.selectedTabIndex == i) {
                tab.selected = true
            }else{
                tab.selected = false
            }
            let tabFrameValue:NSValue = tabFrameArray[i] as! NSValue
            let tabFrame:CGRect = tabFrameValue.cgRectValue
            if (animation) {
                
                UIView.animate(withDuration: 0.15, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    tab.frame = tabFrame
                    tab.browserTabView = self
                    
                    
                    }, completion: nil)
            }
            else{
                tab.frame = tabFrame
                tab.browserTabView = self
                
                
            }
            addSubview(tab)
        }
        
    }
    func removeTab(atIndex index:Int)
    {
        if (index < 0 || index >= tabArray.count) {
            return
        }
        //the last one tab not allowed to remove,return
        if (tabArray.count == 1 || tabArray.count <= 0) {
            return
        }
        if (self.tabWidth < TAB_WIDTH) {
            self.tabWidth = self.bounds.width/CGFloat(self.tabArray.count - 1)
        }
        
        let tab :BrowserTab = tabArray[index] as! BrowserTab
        
        var newIndex :Int = tab.index!
        
        
        //if previous selected index was the last tab ,keep the coming last one selected
        if (index == self.tabArray.count - 1) {
            newIndex = index - 1
        }
        
        tabArray.remove(tab)
        tab.removeFromSuperview()
        
        
        tabWidth = self.bounds.size.width/CGFloat(self.tabArray.count+1)
        var tabIndex :Int = 0
        
        for (index, _) in tabArray.enumerated() {
            let tempTab:BrowserTab = tabArray[index] as! BrowserTab
            tempTab.index = tabIndex
            tabIndex += 1
        }
        
        caculateFrame()
        if(index == self.tabArray.count){
            
            selectTab(atIndex:newIndex, animated: false)
        }
        else{
            
            selectTab(atIndex:newIndex, animated: true)
        }

        delegate?.browserTabViewDidRemoveTab?(browserTabView: self, atIndex: index)
        
    }
    func addTab(title aTitle:String)
    {
        
        //if the new tab is about to be off the tab view's bounds , here simply not adding it
        var title :String  = aTitle
        if (CGFloat(self.tabArray.count) > self.bounds.width * 1.8/TAB_WIDTH) {
            return
        }
        if (self.tabWidth * CGFloat(self.tabArray.count + 1) > self.bounds.width) {
            self.tabWidth = self.bounds.width/CGFloat(self.tabArray.count + 1)
        }
        
        if (title.isEmpty) {
            title = "new Tab"
        }
        let tab:BrowserTab = BrowserTab(browserTabView: self)
        tab.titleField?.text = title
        tabArray.add(tab)
        
        for (index, _) in tabArray.enumerated() {
            let tempTab:BrowserTab = tabArray[index] as! BrowserTab
            tempTab.index = index
            
        }
        caculateFrame()
        selectedTabIndex =  self.tabArray.count - 1
        let tabFrameValue:NSValue = tabFrameArray.lastObject as! NSValue
        let tabFrame:CGRect = tabFrameValue.cgRectValue
        tab.frame = tabFrame
        tab.selected = true
        selectTab(atIndex: selectedTabIndex, animated: false)
    }
    
    
}
