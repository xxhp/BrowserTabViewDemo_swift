//
//  BrowserTab.swift
//  BrowserTabView_Swift
//
//  Created by xiaohaibo on 3/14/15.
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

class BrowserTab: UIView {
    weak var browserTabView : BrowserTabView?
    var titleFont :UIFont?
    var titleField :UITextField?
    var imageView :UIImageView?
    var index :Int?
    fileprivate var closeButton:UIButton  = UIButton(type:UIButtonType.custom) as UIButton
    // Default initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(browserTabView abrowserTabView:BrowserTabView) {
        self.init(frame: CGRect.zero)
        browserTabView = abrowserTabView
        titleFont = UIFont.systemFont(ofSize: 16)
        imageView = UIImageView(frame: self.bounds)
        addSubview(imageView!)
        
        closeButton.setImage(UIImage(named:"tab_close"), for:UIControlState())
        closeButton.addTarget(self, action: #selector(BrowserTab.onCloseTap(_:)), for: UIControlEvents.touchUpInside)
        closeButton.isHidden = true
        addSubview(closeButton)
        
        
        titleField = UITextField(frame: self.bounds) as UITextField
        titleField?.textAlignment = NSTextAlignment.center
        titleField?.isEnabled = false
        addSubview(titleField!)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BrowserTab.handleTap(_:))))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var selected: Bool = false{
        didSet {
            if (selected) {
                
                imageView?.image = UIImage(named:"tab_selected")?.stretchableImage(withLeftCapWidth: 30, topCapHeight:0)
                closeButton.isHidden = !((self.browserTabView?.tabArray.count)! > 1)
 
            }else{
                
                imageView?.image = UIImage(named:"tab_normal")?.stretchableImage(withLeftCapWidth: 30, topCapHeight:0)
                closeButton.isHidden = true
                
            }
            
        }
    }
    override func layoutSubviews() {
        titleField?.frame = self.bounds
        imageView?.frame = self.bounds
        closeButton.frame =  CGRect(x: self.bounds.maxX - 50, y: 0, width: 44, height: 44)
        
    }
    
    func handleTap(_ gestureRecognizer: UITapGestureRecognizer)
    {
        browserTabView?.selectTab(atIndex:self.index!, animated: false)
    }
    func onCloseTap(_ sender:UIButton){
        browserTabView?.removeTab(atIndex: self.index!)
    }
}
