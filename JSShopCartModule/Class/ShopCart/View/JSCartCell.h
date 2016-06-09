//
//  JSCartCell.h
//  JSShopCartModule
//
//  Created by 乔同新 on 16/6/9.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSCartModel,JSNummberCount;

@interface JSCartCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectShopGoodsButton;

@property (weak, nonatomic) IBOutlet JSNummberCount *nummberCount;

@property (nonatomic, strong) JSCartModel *model;

+ (CGFloat)getCartCellHeight;

@end
