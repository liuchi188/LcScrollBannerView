//
//  LcScrollBannerView.swift
//  LcScrollBannerView
//
//  Created by liuchi188 on 15/12/19.
//  Copyright © 2015年 liuchi188. All rights reserved.
//

import Foundation
import UIKit

//pageControl位置
enum PageControlPosition {
    case PageControlLeft
    case PageControlCenter
    case PageControlRight
}

//点击图片的Block回调，参数当前图片的索引，也就是当前页数
typealias TapImageViewButtonClick = (imageIndex: Int) -> Void

class LcScrollBannerView: UIView,  UIScrollViewDelegate{
    
    var scrollInterval:Float!                       //切换图片的时间间隔，可选，默认为3s
    var animationInterVale:Float!                   //运动时间间隔,可选，默认为0.7s
    var imageViewArr: [String]!                     //图片数组
    
    var mainScrollView:UIScrollView!
    var mainPageControl:UIPageControl!
    
    var widthOfView:CGFloat!
    var heightOfView:CGFloat!
    var currentPage = 1
    var timer:NSTimer!
    var imageViewcontentModel:UIViewContentMode!
    var imageViewPageControl:UIPageControl!
    var pageControlPosition:PageControlPosition!
    var pageControlSpacing:CGFloat = 15
    
    var action: TapImageViewButtonClick?
    
    
    init(frame: CGRect,imageArr:[String], pcp:PageControlPosition, action: TapImageViewButtonClick) {
        super.init (frame: frame)
        self.action = action
        self.imageViewArr = imageArr
        self.pageControlPosition = pcp
        commonInit()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addObserver(self, forKeyPath: "bounds" as String, options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "bounds" {
            commonInit()
        }
    }
    
    func initSb(imageArr:[String], pcp: PageControlPosition, action: TapImageViewButtonClick) {
        
        self.action = action
        self.imageViewArr = imageArr
        self.pageControlPosition = pcp
        commonInit()
    }
    
    func commonInit() {
        widthOfView = frame.width
        heightOfView = frame.height
        scrollInterval = 3
        animationInterVale = 0.7
        currentPage = 1
        imageViewcontentModel = UIViewContentMode.ScaleAspectFill
        self.clipsToBounds = true
        initMainScrollView()
        addImageviewsForMainScroll()
        addTimerLoop()
        addPageControl()
        initImageViewButton()
    }
    
    /**
     *  初始化ScrollView
     */
    func initMainScrollView(){
        mainScrollView = UIScrollView(frame: CGRectMake(0, 0, widthOfView, heightOfView))
        mainScrollView.contentSize = CGSizeMake(widthOfView, 0)
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.pagingEnabled = true
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.alwaysBounceVertical = false
        mainScrollView.directionalLockEnabled = true
        mainScrollView.delegate = self
        self.addSubview(mainScrollView)
    }
    
    /**
     *  给ScrollView添加ImageView
     */
    func addImageviewsForMainScroll(){
        if imageViewArr != nil {
            mainScrollView.contentSize = CGSizeMake(widthOfView * CGFloat(imageViewArr.count + 2), 0)
            for var i = 0; i < imageViewArr.count + 2; i++ {
                let currentFrame = CGRectMake(widthOfView * CGFloat(i), 0, widthOfView, heightOfView)
                let tempImageView = UIImageView(frame: currentFrame)
                tempImageView.contentMode = imageViewcontentModel
                tempImageView.clipsToBounds = true
                var imageName = ""
                if i == 0 {
                    imageName = imageViewArr[imageViewArr.count - 2]
                }else if i == 1 {
                    imageName = imageViewArr.last!
                }else{
                    imageName = imageViewArr[i - 2]
                }
                if self.verifyURL(imageName) {
                    tempImageView.sd_setImageWithURL(NSURL(string: imageName), placeholderImage: UIImage(named: "default-banner"))
                }else{
                    let imageTemp = UIImage(named: imageName)
                    tempImageView.image = imageTemp
                }
                mainScrollView.addSubview(tempImageView)
            }
            mainScrollView.contentOffset = CGPointMake(widthOfView * 2, 0)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.resumeTimer()
        //滑动后到达的图片位置
        let cp = Int(scrollView.contentOffset.x / widthOfView)
        //倒滑到第一位置
        if cp == 0 {
            mainScrollView.contentOffset = CGPointMake(widthOfView * CGFloat(imageViewArr.count), 0)
            imageViewPageControl.currentPage = imageViewArr.count - 2
            currentPage = imageViewArr.count - 1
            return
        }
        //正滑
        if currentPage + 2 == cp || currentPage > cp && cp == 2{
            currentPage++
            if currentPage == imageViewArr.count + 1 {
                currentPage = 1
            }
            if currentPage == imageViewArr.count {
                mainScrollView.contentOffset = CGPointMake(widthOfView, 0)
            }
            imageViewPageControl.currentPage = currentPage - 1
            return
        }else{
            if currentPage == 1 {
                currentPage = imageViewArr.count
            }else{
                currentPage--
            }
            imageViewPageControl.currentPage = currentPage - 1
        }
        
    }
    
    /**
     *  暂停定时器
     */
    func resumeTimer(){
        if !timer.valid {
            return
        }
        timer.fireDate = NSDate(timeIntervalSinceNow: NSTimeInterval(scrollInterval - animationInterVale))
    }
    
    /**
     *  定时循环
     */
    func addTimerLoop(){
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(scrollInterval), target: self, selector: "changeOffset", userInfo: nil, repeats: true)
        }
        
    }
    
    func changeOffset(){
        currentPage++
        
        if currentPage == imageViewArr.count + 1 {
            currentPage = 1
        }
        UIView.animateWithDuration(
            NSTimeInterval(animationInterVale),
            animations: {
                self.mainScrollView.contentOffset = CGPointMake(self.widthOfView * CGFloat(self.currentPage + 1), 0)
            },
            completion: {
                finished in
                if self.currentPage == self.imageViewArr.count {
                    self.mainScrollView.contentOffset = CGPointMake(self.widthOfView, 0)
                }
        })
        imageViewPageControl.currentPage = currentPage - 1
    }
    
    /**
     *  检查是不为网络地址
     */
    func verifyURL(url:String) -> Bool{
        return RegexUtil("((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?").test(url)
    }
    
    /**
     *  添加PageControl
     */
    func addPageControl(){
        
        imageViewPageControl = UIPageControl(frame: CGRectMake(0, heightOfView - 20, widthOfView, 20))
        let pointSize = imageViewPageControl.sizeForNumberOfPages(imageViewArr.count)
        var _x = (imageViewPageControl.bounds.size.width - pointSize.width) / 2
        
        switch pageControlPosition! {
        case .PageControlLeft:
            _x = _x - self.pageControlSpacing
            break
        case .PageControlCenter:
            _x = 0
            break
        case .PageControlRight:
            _x = -(_x) + self.pageControlSpacing
            break
        }
        
        imageViewPageControl.bounds = CGRectMake(_x, 0, imageViewPageControl.bounds.size.width, imageViewPageControl.bounds.size.height)
        imageViewPageControl.numberOfPages = imageViewArr.count
        imageViewPageControl.currentPage = currentPage - 1
        imageViewPageControl.tintColor = UIColor.blackColor()
        self.addSubview(imageViewPageControl)
    }
    
    /**
     *  图片按钮
     */
    func initImageViewButton(){
        for var i = 0; i < imageViewArr.count; i++ {
            let currentFrame = CGRectMake(widthOfView * CGFloat(i+1), 0, widthOfView, heightOfView)
            let tempButton = UIButton(frame: currentFrame)
            tempButton.addTarget(self, action: "tapImageButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
            if i == 0 {
                tempButton.tag = imageViewArr.count
            }else{
                tempButton.tag = i
            }
            mainScrollView.addSubview(tempButton)
        }
    }
    
    //图片单击事件
    func tapImageButtonClick(sender:UIButton){
        self.action!(imageIndex: sender.tag)
    }
    
}