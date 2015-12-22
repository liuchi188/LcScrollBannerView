//
//  ViewController.swift
//  LcScrollBannerView
//
//  Created by 刘驰 on 15/12/19.
//  Copyright © 2015年 刘驰. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bannerView: LcScrollBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageArray = ["001.jpg", "002.jpg", "003.jpg", "004.jpg", "005.jpg", "http://pic1.nipic.com/2008-12-25/2008122510134038_2.jpg"]
        bannerView.initSb(
            imageArray,
            pcp:.PageControlRight,
            action: {
                index in
                print("我是第\(index)张图片")
        })
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

