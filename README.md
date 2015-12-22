# LcScrollBannerView
iOS图片轮播,可以前后循环滚动，考虑自https://github.com/lizelu/ZLImageViewDisplay。
在此基础上加入向后循环滑动功能。

### 效果图
![image](https://github.com/liuchi188/LcScrollBannerView/blob/master/lcScrollBannerView_image.png)

## 运行环境
- iOS8.1 or later
- Xcode 7.0

## 使用方法

1.将代码中LcScrollBannerView.swift拖入项目中
2.项目中集成了SDWebImage
3.viewController中加入下面代码

```swift
let imageArray = ["001.jpg", "002.jpg", "003.jpg", "004.jpg", "005.jpg", "http://pic1.nipic.com/2008-12-25/2008122510134038_2.jpg"]
bannerView.initSb(
  	imageArray,
    pcp:.PageControlRight,
    action: {
        index in
        print("我是第\(index)张图片")
    })

