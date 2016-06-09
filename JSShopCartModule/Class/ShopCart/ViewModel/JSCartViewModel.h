//
//  JSCartViewModel.h
//  JSShopCartModule
//
//  Created by 乔同新 on 16/6/9.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSCartViewController;

@interface JSCartViewModel : NSObject

@property (nonatomic, strong) NSMutableArray       *cartData;
@property (nonatomic, weak  ) JSCartViewController *cartVC;
@property (nonatomic, weak  ) UITableView          *cartTableView;
/**
 *  存放店铺选中
 */
@property (nonatomic, strong) NSMutableArray       *shopSelectArray;
/**
 *  carbar 观察的属性变化
 */
@property (nonatomic, assign) float                 allPrices;
/**
 *  carbar 全选的状态
 */
@property (nonatomic, assign) BOOL                   isSelectAll;
//获取数据
- (void)getData;
//全选
- (void)selectAll:(BOOL)isSelect;
//row select
- (void)rowSelect:(BOOL)isSelect IndexPath:(NSIndexPath *)indexPath;
//row change quantity
- (void)rowChangeQuantity:(NSInteger)quantity indexPath:(NSIndexPath *)indexPath;
//获取价格
- (float)getAllPrices;

@end
