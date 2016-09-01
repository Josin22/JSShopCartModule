

# JSShopCartModule

[![GitHub license](https://img.shields.io/badge/platform-ios-green.svg
)](https://github.com/josin22/JSShopCartModule)
![GitHub license](https://img.shields.io/badge/license-MIT-green.svg)
[![CocoaPods Compatible](https://img.shields.io/badge/build-passing-green.svg)](https://github.com/josin22/JSShopCartModule)


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

<<<<<<< HEAD
## 项目搭建框架
整体文件目录按照模块分一下子文件

	ViewController :
		ViewController				##加载视图事件监听等等
	Model :
		model						##基本数据模型
	View : 
		cell						##cell
		numbercount					##封装加减控件
		header						##店铺之类
		footer						##小结
		cartbar					    ##封装购物车底部view
	ViewModel :
		service						##抽离tableview的datasource和delegate
		viewmodel				    ##处理主要的逻辑和数据
	
## viewmodel类方法属性解析

### 获取数据方法

1.循环20个从0到5之间随机取数组里取值加到最终的cartData数组里
2.店铺选择shopSelectArray默认NO状态
3.统计总共购物车数量cartGoodsCount

	- (void)getData{
	    //数据个数
	    NSInteger allCount = 20;
	    NSInteger allGoodsCount = 0;
	    NSMutableArray *storeArray = [NSMutableArray arrayWithCapacity:allCount];
	    NSMutableArray *shopSelectAarry = [NSMutableArray arrayWithCapacity:allCount];
	    //创造店铺数据
	    for (int i = 0; i<allCount; i++) {
	        //创造店铺下商品数据
	        NSInteger goodsCount = [_shopGoodsCount[self.random] intValue];
	        NSMutableArray *goodsArray = [NSMutableArray arrayWithCapacity:goodsCount];
	        for (int x = 0; x<goodsCount; x++) {
	            JSCartModel *cartModel = [[JSCartModel alloc] init];
	            cartModel.p_id         = @"122115465400";
	            cartModel.p_price      = [_goodsPriceArray[self.random] floatValue];
	            cartModel.p_name       = [NSString stringWithFormat:@"%@这是一个很长很长的名字呀呀呀呀呀呀",@(x)];
	            cartModel.p_stock      = 22;
	            cartModel.p_imageUrl   = _goodsPicArray[self.random];
	            cartModel.p_quantity   = [_goodsQuantityArray[self.random] integerValue];
	            [goodsArray addObject:cartModel];
	            allGoodsCount++;
	        }
	        [storeArray addObject:goodsArray];
	        [shopSelectAarry addObject:@(NO)];
	    }
	    self.cartData = storeArray;
	    self.shopSelectArray = shopSelectAarry;
	    self.cartGoodsCount = allGoodsCount;
	}


#### 获取当前选中价格总和方法

对cartData数组转信号流然后map自定义需求return,期间自定义需求参数value 再次转信号流经过filter筛选未选中使isSelectAll为NO,然后经过map自定义需求使model.p_quantity*model.p_price得到的商品总价返回,最终return得到商品总价数组pricesArray.

快速遍历pricesArray得出总价allPrices 

	- (float)getAllPrices{
	    
	    __block float allPrices   = 0;
	    NSInteger shopCount       = self.cartData.count;
	    NSInteger shopSelectCount = self.shopSelectArray.count;
	    if (shopSelectCount == shopCount && shopCount!=0) {
	        self.isSelectAll = YES;
	    }
	    NSArray *pricesArray = [[[self.cartData rac_sequence] map:^id(NSMutableArray *value) {
	        return [[[value rac_sequence] filter:^BOOL(JSCartModel *model) {
	            if (!model.isSelect) {
	                self.isSelectAll = NO;
	            }
	            return model.isSelect;
	        }] map:^id(JSCartModel *model) {
	            return @(model.p_quantity*model.p_price);
	        }];
	    }] array];
	    for (NSArray *priceA in pricesArray) {
	        for (NSNumber *price in priceA) {
	            allPrices += price.floatValue;
	        }
	    }
	    
	    return allPrices;
	}


### 全选yes or not

shopSelectArray转流map定义需求isSelect为YES的对象然后return 成可变数组.

cartData转流map定义需求,对其参数value转流map定义需求KVC使model的isSelect属性为YES,再次计算记录总价allPrices.return再return成可变数组.


	- (void)selectAll:(BOOL)isSelect{
	    
	     __block float allPrices = 0;
	    
	    self.shopSelectArray = [[[[self.shopSelectArray rac_sequence] map:^id(NSNumber *value) {
	        return @(isSelect);
	    }] array] mutableCopy];
	    self.cartData = [[[[self.cartData rac_sequence] map:^id(NSMutableArray *value) {
	        return  [[[[value rac_sequence] map:^id(JSCartModel *model) {
	                [model setValue:@(isSelect) forKey:@"isSelect"];
	            if (model.isSelect) {
	                allPrices += model.p_quantity*model.p_price;
	            }
	            return model;
	        }] array] mutableCopy];
	    }] array] mutableCopy];
	    self.allPrices = allPrices;
	    [self.cartTableView reloadData];
	}


### 单行选择处理方法

KVC设置model的isSelect为YES,做店铺下商品选中满判断

	- (void)rowSelect:(BOOL)isSelect IndexPath:(NSIndexPath *)indexPath{
	    
	    NSInteger section          = indexPath.section;
	    NSInteger row              = indexPath.row;
	
	    NSMutableArray *goodsArray = self.cartData[section];
	    NSInteger shopCount        = goodsArray.count;
	    JSCartModel *model         = goodsArray[row];
	    [model setValue:@(isSelect) forKey:@"isSelect"];
	    //判断是都到达足够数量
	    NSInteger isSelectShopCount = 0;
	    for (JSCartModel *model in goodsArray) {
	        if (model.isSelect) {
	            isSelectShopCount++;
	        }
	    }
	    [self.shopSelectArray replaceObjectAtIndex:section withObject:@(isSelectShopCount==shopCount?YES:NO)];
	    
	    [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
	    
	    /*重新计算价格*/
	    self.allPrices = [self getAllPrices];
	}


###  单行数量处理方法

KVC处理model.再次调用getAllPrices方法计算总价

	- (void)rowChangeQuantity:(NSInteger)quantity indexPath:(NSIndexPath *)indexPath{
	    
	    NSInteger section  = indexPath.section;
	    NSInteger row      = indexPath.row;
	
	    JSCartModel *model = self.cartData[section][row];
	
	    [model setValue:@(quantity) forKey:@"p_quantity"];
	    
	    [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
	    
	    /*重新计算价格*/
	    self.allPrices = [self getAllPrices];
	}


###  左滑删除商品

数组删除,做店铺下商品删除完判断处理

	- (void)deleteGoodsBySingleSlide:(NSIndexPath *)path{
	    
	    NSInteger section = path.section;
	    NSInteger row     = path.row;
	    
	    NSMutableArray *shopArray = self.cartData[section];
	    [shopArray removeObjectAtIndex:row];
	    if (shopArray.count == 0) {
	        /*1 删除数据*/
	        [self.cartData removeObjectAtIndex:section];
	        /*2 删除 shopSelectArray*/
	        [self.shopSelectArray removeObjectAtIndex:section];
	        [self.cartTableView reloadData];
	    } else {
	        [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
	    }
	    self.cartGoodsCount-=1;
	    /*重新计算价格*/
	    self.allPrices = [self getAllPrices];
	}


### 删除选中处理方法

创建可变集合shopSelectIndex,遍历cartData,遍历shopArray,取得选中的index2加到selectIndexSet中,做店铺count和选中商品相等判断,index1加到shopSelectIndex中,cartGoodsCount做递减处理,然后依次shopArray做删除操作,cartData在循环外删除操作,shopSelectArray在循环外删除操作,价格为0,重新计算价格

	- (void)deleteGoodsBySelect{
	 
	    /*1 删除数据*/
	    NSInteger index1 = -1;
	    NSMutableIndexSet *shopSelectIndex = [NSMutableIndexSet indexSet];
	    for (NSMutableArray *shopArray in self.cartData) {
	        index1++;
	        
	        NSInteger index2 = -1;
	        NSMutableIndexSet *selectIndexSet = [NSMutableIndexSet indexSet];
	        for (JSCartModel *model in shopArray) {
	            index2++;
	            if (model.isSelect) {
	                [selectIndexSet addIndex:index2];
	            }
	        }
	        NSInteger shopCount = shopArray.count;
	        NSInteger selectCount = selectIndexSet.count;
	        if (selectCount == shopCount) {
	            [shopSelectIndex addIndex:index1];
	            self.cartGoodsCount-=selectCount;
	        }
	        [shopArray removeObjectsAtIndexes:selectIndexSet];
	    }
	    [self.cartData removeObjectsAtIndexes:shopSelectIndex];
	    /*2 删除 shopSelectArray*/
	    [self.shopSelectArray removeObjectsAtIndexes:shopSelectIndex];
	    [self.cartTableView reloadData];
	    /*3 carbar 恢复默认*/
	    self.allPrices = 0;
	    /*重新计算价格*/
	    self.allPrices = [self getAllPrices];
	}


## VC做监听观察处理

###  全选
	 [[self.cartBar.selectAllButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
	        x.selected = !x.selected;
	        [self.viewModel selectAll:x.selected];
	    }];

### 删除

    [[self.cartBar.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        [self.viewModel deleteGoodsBySelect];
    }];

### 结算
	[[self.cartBar.balanceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
	        
	    }];

### 观察价格属性

	WEAK
    [RACObserve(self.viewModel, allPrices) subscribeNext:^(NSNumber *x) {
        STRONG
        self.cartBar.money = x.floatValue;
    }];

### 全选状态
	
	RAC(self.cartBar.selectAllButton,selected) = RACObserve(self.viewModel, 	isSelectAll);

### title购物车数量

    [RACObserve(self.viewModel, cartGoodsCount) subscribeNext:^(NSNumber *x) {
       STRONG
        if(x.integerValue == 0){
            self.title = [NSString stringWithFormat:@"购物车"];
        } else {
            self.title = [NSString stringWithFormat:@"购物车(%@)",x];
        }
        
    }];


## 总结
主要的方法我都一一讲了很清楚,具体的怎么调用,可以到service里,cell里,控件里看,写了这么一大堆,如果你还有什么不懂,或者有更好的建议请留言,或者到[我的github](https://github.com/Josin22/JSShopCartModule)上issue我,如果我写的对你有些帮助,请给予辛劳的博主一些打赏,谢谢~

