//
//  JSCartViewModel.m
//  JSShopCartModule
//
//  Created by 乔同新 on 16/6/9.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "JSCartViewModel.h"
#import "JSCartModel.h"

@interface JSCartViewModel (){
    
    NSArray *_shopGoodsCount;
    NSArray *_goodsPicArray;
    NSArray *_goodsPriceArray;
    NSArray *_goodsQuantityArray;
    
}
//随机获取店铺下商品数
@property (nonatomic, assign) NSInteger random;
@end

@implementation JSCartViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        //6
        _shopGoodsCount  = @[@(1),@(8),@(5),@(2),@(4),@(4)];
         _goodsPicArray  = @[@"http://pic.5tu.cn/uploads/allimg/1606/pic_5tu_big_2016052901023305535.jpg",
                            @"http://pic.5tu.cn/uploads/allimg/1605/pic_5tu_big_2016052901023303745.jpg",
                            @"http://pic.5tu.cn/uploads/allimg/1605/pic_5tu_big_201605291711245481.jpg",
                            @"http://pic.5tu.cn/uploads/allimg/1605/pic_5tu_big_2016052901023285762.jpg",
                            @"http://pic.5tu.cn/uploads/allimg/1506/091630516760.jpg",
                            @"http://pic.5tu.cn/uploads/allimg/1506/091630516760.jpg"];
        _goodsPriceArray = @[@(30.45),@(120.09),@(7.8),@(11.11),@(56.1),@(12)];
        _goodsQuantityArray = @[@(12),@(21),@(1),@(10),@(3),@(5)];
    }
    return self;
}

- (NSInteger)random{
    
    NSInteger from = 0;
    NSInteger to   = 5;
    
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
    
}

#pragma mark - make data

- (void)getData{
    //数据个数
    NSInteger allCount = 20;
    NSMutableArray *storeArray = [NSMutableArray arrayWithCapacity:allCount];
    NSMutableArray *shopSelectAarry = [NSMutableArray arrayWithCapacity:allCount];
    //创造店铺数据
    for (int i = 0; i<allCount; i++) {
        //创造店铺下商品数据
        NSInteger goodsCount = [_shopGoodsCount[self.random] intValue];
        NSMutableArray *goodsArray = [NSMutableArray arrayWithCapacity:goodsCount];
        for (int x = 0; x<goodsCount; x++) {
            JSCartModel *cartModel = [[JSCartModel alloc] init];
            cartModel.p_id = @"122115465400";
            cartModel.p_price = [_goodsPriceArray[self.random] floatValue];
            cartModel.p_name = [NSString stringWithFormat:@"%@这是一个很长很长的名字呀呀呀呀呀呀",@(x)];
            cartModel.p_stock = 22;
            cartModel.p_imageUrl = _goodsPicArray[self.random];
            cartModel.p_quantity = [_goodsQuantityArray[self.random] integerValue];
            [goodsArray addObject:cartModel];
        }
        [storeArray addObject:goodsArray];
        [shopSelectAarry addObject:@(NO)];
    }
    self.cartData = storeArray;
    self.shopSelectArray = shopSelectAarry;
}

- (float)getAllPrices{
    
    __block float allPrices = 0;
    NSInteger shopCount = self.cartData.count;
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

- (void)rowSelect:(BOOL)isSelect IndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSMutableArray *goodsArray = self.cartData[section];
    NSInteger shopCount = goodsArray.count;
    JSCartModel *model = goodsArray[row];
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
    
    self.allPrices = [self getAllPrices];
}

- (void)rowChangeQuantity:(NSInteger)quantity indexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    JSCartModel *model = self.cartData[section][row];

    [model setValue:@(quantity) forKey:@"p_quantity"];
    
    [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    
    self.allPrices = [self getAllPrices];
}

@end
