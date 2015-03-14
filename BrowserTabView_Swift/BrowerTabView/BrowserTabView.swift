//
//  BrowserTabView.swift
//  BrowserTabView_Swift
//
//  Created by xiaohaibo on 3/11/15.
//  Copyright (c) 2015 xiaohaibo. All rights reserved.
//
//  github:https://github.com/xxhp/BrowserTabView_Swift
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
    func finished();
}

let TAB_FOOTER_HEIGHT:CGFloat = 5
let DEFAULT_TAB_WIDTH:CGFloat = 154
let defaultFrame:CGRect = CGRectMake(0, 0, 1024, 44);
let kDefaultTabWidth:CGFloat = 154;
class BrowserTabView: UIView {
    weak var delegate:BrowserTabViewDelegate?
    var tabWidth:CGFloat = kDefaultTabWidth;
    var tabFrameArray = NSMutableArray();
    var backgroundImage:UIImage?;
    var tabArray = NSMutableArray();
    var selectedTabIndex :Int = 0;
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 242.0/255, green: 242.0/255, blue: 242.0/255, alpha: 1);
        backgroundImage = UIImage(named:"tab_background");
    }
    convenience init(Titles titles: Array<String>, Delegate delegate:BrowserTabViewDelegate) {
        self.init(frame:defaultFrame);
        self.delegate = delegate;
        for (i, title) in enumerate(titles) {
            var tab:BrowserTab? = BrowserTab(BrowserTabView: self);
            
            tab?.titleField?.text = title;
            tab?.index = i;
            self.tabArray.addObject(tab!);
        }
       
        self.tabWidth = self.bounds.size.width/CGFloat(self.tabArray.count+1);
        caculateFrame();
        
        
        
        if (self.tabArray.count>0) {
//            [self setSelectedTabIndex:0 animated:NO];
            selectedIndex(TabIndex:0, animated:false);
        }


    }
    override func drawRect(rect:CGRect) {
        var height : CGFloat = self.bounds.size.height;
        
        //left 5 dp to show the background, and give a look that tab has footer
//        [_backgroundImage drawInRect:CGRectMake(0, 0, self.frame.size.width, height - TAB_FOOTER_HEIGHT)];
       
        backgroundImage?.drawAsPatternInRect(CGRectMake(0, 0, self.frame.size.width, height - TAB_FOOTER_HEIGHT));
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func caculateFrame(){
    
        let overlapWidth:CGFloat = 15;
        var height:CGFloat = CGRectGetHeight(self.bounds);
        var right:CGFloat = 0;
        
        tabFrameArray.removeAllObjects();
        
        for (var i:Int = 0; i < self.tabArray.count; i++) {
            var tabFrame:CGRect = CGRectMake(right, 0, self.tabWidth, height - TAB_FOOTER_HEIGHT);
//            [_tabFramesArray addObject:[NSValue valueWithCGRect:tabFrame]];
            tabFrameArray.addObject(NSValue(CGRect:tabFrame));
            right += (self.tabWidth - overlapWidth);
        }

    
    }
    
    func selectedIndex(TabIndex index:Int, animated animation:Bool){
      
        selectedTabIndex = index;
 
    //tabs before the selected are added in sequence from the first to the selected ;
        for (var i : Int = 0; i < selectedTabIndex; i++) {
            
            var tabFrameValue:NSValue = tabFrameArray[i] as NSValue;
            var tabFrame:CGRect = tabFrameValue.CGRectValue();
            var tab :BrowserTab = tabArray[i] as BrowserTab;
            if (animation) {
                
                UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    tab.frame = tabFrame;
                    tab.browserTabView = self;
                    tab.selected = false;
                    
                    }, completion: nil)
            }
            else{
                tab.frame = tabFrame;
                tab.browserTabView = self;
                tab.selected = false;
                
            }
            addSubview(tab);
        
        }
        
        //tabs after the selected are added in sequence from the last to the selected ;
        for (var i : Int = tabArray.count - 1; i >= selectedTabIndex; i--) {
            var tab :BrowserTab = tabArray[i] as BrowserTab;
            if (self.selectedTabIndex == i) {
                tab.selected = true;
            }else{
                tab.selected = false;
            }
            var tabFrameValue:NSValue = tabFrameArray[i] as NSValue;
            var tabFrame:CGRect = tabFrameValue.CGRectValue();
            if (animation) {
                
                UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    tab.frame = tabFrame;
                    tab.browserTabView = self;
                    
                    
                    }, completion: nil)
            }
            else{
                tab.frame = tabFrame;
                tab.browserTabView = self;
                
                
            }
            addSubview(tab);
        }
        
    }
 
    
}
