//
//  JSCartHeaderView.h
//  JSShopCartModule
//
//  Created by 乔同新 on 16/6/9.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSCartHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIButton *selectStoreGoodsButton;

+ (CGFloat)getCartHeaderHeight;

@end
