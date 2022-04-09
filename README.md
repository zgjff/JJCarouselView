JJCarouselView
=================

[![GitHub](https://img.shields.io/github/license/zgjff/JJCarouselView)](https://www.apache.org/licenses/LICENSE-2.0.html)
![swift-5.6](https://img.shields.io/badge/swift-5.6-blue)
![iOS-11.0](https://img.shields.io/badge/iOS-11.0-red)
[![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/zgjff/JJCarouselView)](https://github.com/zgjff/JJCarouselView)
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![Cocoapods](https://img.shields.io/cocoapods/v/JJCarouselView)](https://cocoapods.org/pods/JJCarouselView)

适用于Swift的简单好用、易于扩展的轮播图框架

使用方法
=================

## 一、初始化
因为本轮播图是泛型控件,所以在初始化的时候需要指定类型。
```swift
let carouselView: JJCarouselView<UIImageView, UIImage> = JJCarouselView(frame: CGRect(x: 50, y: 0, width: 300, height: 200), initialize: nil)
```

## 二、使用方法

### 2.1 基本设置
轮播图方向,默认横向轮播
```swift
cv.config.direction = .vertical
```

是否自动轮播,默认`true`自动轮播
```swift
cv.config.autoLoop = true
```

轮播间隔,默认5s
```swift
cv.config.loopTimeInterval = 5
```

轮播图内边局
```swift
cv.config.contentInset = .zero
```

点击事件
```swift
cv.onTap = { obj, index in
    ...
}
```

### 2.2 展示数据
> 本控件没指定将对应的数据源显示到容器的方法,所以需要你自己去实现。只要在初始化`JJCarouselView`之后,设置`config.display`即可。

#### 2.2.1 以最简单的展示本地图片的轮播图为例:
```swift
let carouselView: JJCarouselView<UIImageView, UIImage>
cv.config.display = { cell, image in
    cell.clipsToBounds = true
    cell.contentMode = .scaleAspectFill
    cell.image = image
}
```

#### 2.2.2 展示网络图片
```swift
let carouselView: JJCarouselView<UIImageView, URL>
cv.config.display = { cell, url in
    ...
    // 使用SDWebImage
    cell.sd_setImage(with: url)
    // 使用Kingfisher
    cell.kf.setImage(with: url)
}
```

#### 2.2.3 展示任何你想轮播的内容
可以使用任何`UIView`的子类来展示任意对象,只需设定轮播图类型的`Object`遵守`Equatable`协议即。
```swift
// 轮播Model,必须遵守Equatable协议
struct WebCarouselModel {
    let title: String
    let desc: String
    let url: URL
}

extension WebCarouselModel: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return (lhs.title == rhs.title) && (lhs.desc == rhs.desc)
    }
}
```
```swift
// 轮播控件
final class WebCarouselView: UIView {}
```
```swift
let cv: JJCarouselView<WebCarouselView, WebCarouselModel> = JJCarouselView(frame: CGRect(x: 50, y: 0, width: 200, height: 150), initialize: nil)
cv.config.display = { cell, object in
    cell.titleLabel.text = object.title
    cell.descLabel.text = object.desc
}
cv.datas = [
    WebCarouselModel(title: "这是第1个自定义轮播控件", desc: "这是第1个自定义轮播控件", url: URL(string: "https://www.baidu.com")!),
    WebCarouselModel(title: "这是第2个自定义轮播控件", desc: "这是第2个自定义轮播控件", url: URL(string: "https://www.zhihu.com")!),
    WebCarouselModel(title: "这是第3个自定义轮播控件", desc: "这是第3个自定义轮播控件", url: URL(string: "https://cn.bing.com")!),
]
```

### 2.3 轮播指示器

#### 2.3.1 指示器控件
轮播图的`pageView`是可替换的,只需要替换成遵守`JJCarouselViewPageable`协议的类类即可。
```swift
cv.pageView = JJCarouselNumberPageView()
```
隐藏指示器,只需要将`pageView`设置成`JJCarouselEmptyPageView`。
```swift
cv.pageView = JJCarouselEmptyPageView()
```
当然你也可以自定义专属于你的指示器
```swift
class YourOwnPageView: UIView, JJCarouselViewPageable {
    ...
}
```
```swift
cv.pageView = YourOwnPageView()
```

#### 2.3.2 指示器控件`frame`
默认底部居中显示指示器,当然你也可以设定任何位置。
```swift
// 根据数量来设定frame
cv.config.pageViewFrame = { pageView, _, carouselViewSize, totalDataCount in
    let pageSize = pageView.size(forNumberOfPages: totalDataCount)
    return CGRect(x: carouselViewSize.width - pageSize.width - 12, y: carouselViewSize.height - pageSize.height - 10, width: pageSize.width, height: pageSize.height)
}
```
```swift
// 固定大小
cv.config.pageViewFrame = { _, _, carouselViewSize, _ in
    return CGRect(x: carouselViewSize.width - 55, y: carouselViewSize.height - 30, width: 45, height: 20)
}
```


Requirements
=================
* iOS 11.0+
* Swift 5+

Installation
=================
Swift Package Manager
* File > Swift Packages > Add Package Dependency
* Add https://github.com/zgjff/JJCarouselView.git

Cocoapods
```
use_frameworks!
pod 'JJCarouselView'
```
