---

 基于ReactiveCocoa和MVVM设计的购物车基本操作实现代码解析

--- 
# 开始之前你需要了解的


## 配置CocoaPods
安装[CocoaPods](https://cocoapods.org/)命令

	 gem install cocoapods   ##使用RVM安装的Ruby不需要sudo

## 配置ReactiveCocoa
然后在你的Podfile添加一下代码
		
	platform :ios, '8.0'
	use_frameworks!
	
	target '你的项目工程名' do
	  pod 'ReactiveCocoa'
	end
	
最后输入命令安装

	pod install
	
另外常用的pod 命令

	pod install --verbose --no-repo-update       ##安装不更新的
	pod update --verbose --no-repo-update        ##更新需要更新的
打开 你的项目工程名.xcworkspace 即可~

RAC在此我就不仔细介绍了,先推荐几遍文章:

 Mattt Thompson写的[Reactive​Cocoa](http://nshipster.com/reactivecocoa/)
 
 Ash Furrow写的 [Getting Started with ReactiveCocoa](http://www.teehanlax.com/blog/getting-started-with-reactivecocoa/)


## 了解MVVM
Google了看几篇有关的文章

 [Basic MVVM with ReactiveCocoa](http://cocoasamurai.blogspot.sg/2013/03/basic-mvvm-with-reactivecocoa.html)

[MVVM-IOS-Example](https://github.com/Machx/MVVM-IOS-Example)

[MVVM 介绍](https://objccn.io/issue-13-1/) 译 朱宏旭
	
简单的介绍一下:
	
M:model放一些数据模型

V:view视图

V:viewcontroller控制器

VM:viewmodel主要做处理逻辑和处理数据

---

# 开始着手代码

## 项目演示

![image](https://raw.githubusercontent.com/Josin22/JSShopCartModule/master/Source/gig1.gif)


更详细的请移步到[我的博客](http://localhost:4000/2016/08/06/20160806/),谢谢

更详细的请移步到[我的博客](http://localhost:4000/2016/08/06/20160806/),谢谢

更详细的请移步到[我的博客](http://localhost:4000/2016/08/06/20160806/),谢谢

---

