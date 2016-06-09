//
//  JSCartFooterView.m
//  JSShopCartModule
//
//  Created by 乔同新 on 16/6/9.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "JSCartFooterView.h"
#import "JSCartModel.h"

@interface JSCartFooterView ()

@property (nonatomic, retain) UILabel *priceLabel;

@end

@implementation JSCartFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self initCartFooterView];
    }
    return self;
}

- (void)initCartFooterView{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.text = @"小记:￥15.80";
    _priceLabel.textColor = [UIColor redColor];
    
    [self addSubview:_priceLabel];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    _priceLabel.frame = CGRectMake(10, 0.5, XNWindowWidth-20, 30);

}

- (void)setShopGoodsArray:(NSMutableArray *)shopGoodsArray{
    
    _shopGoodsArray = shopGoodsArray;
    
    NSArray *pricesArray = [[[_shopGoodsArray rac_sequence] map:^id(JSCartModel *model) {
        
        return @(model.p_quantity*model.p_price);
        
    }] array];
    
    float shopPrice = 0;
    for (NSNumber *prices in pricesArray) {
        shopPrice += prices.floatValue;
    }
    _priceLabel.text = [NSString stringWithFormat:@"小记:￥%.2f",shopPrice];
}


+ (CGFloat)getCartFooterHeight{
    
    return 30;
}

@end
