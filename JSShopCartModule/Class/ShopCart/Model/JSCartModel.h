//
//  JSCartModel.h
//  JSShopCartModule
//
//  Created by 乔同新 on 16/6/9.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSCartModel : NSObject

@property (nonatomic, strong) NSString  *p_id;

@property (nonatomic, assign) float     p_price;

@property (nonatomic, strong) NSString  *p_name;

@property (nonatomic, strong) NSString  *p_imageUrl;

@property (nonatomic, assign) NSInteger p_stock;

@property (nonatomic, assign) NSInteger p_quantity;

//商品是否被选中
@property (nonatomic, assign) BOOL      isSelect;

@end
