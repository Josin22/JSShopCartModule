//
//  JSCartHeaderView.m
//  JSShopCartModule
//
//  Created by 乔同新 on 16/6/9.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "JSCartHeaderView.h"

@interface JSCartHeaderView()

@property (nonatomic, strong) UIButton *storeNameButton;

@end

@implementation JSCartHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self setHeaderUI];
    }
    return self;
}

- (void)setHeaderUI{
    
     self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.selectStoreGoodsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectStoreGoodsButton.frame = CGRectZero;
    [self.selectStoreGoodsButton setImage:[UIImage imageNamed:@"xn_circle_normal"]
                             forState:UIControlStateNormal];
    [self.selectStoreGoodsButton setImage:[UIImage imageNamed:@"xn_circle_select"]
                             forState:UIControlStateSelected];
    self.selectStoreGoodsButton.backgroundColor=[UIColor clearColor];
//    [self.selectStoreGoodsButton addTarget:self action:@selector(selectShopGoods:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectStoreGoodsButton];
    
    self.storeNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.storeNameButton.frame = CGRectZero;
    [self.storeNameButton setTitle:@"店铺名字_____"
                      forState:UIControlStateNormal];
    [self.storeNameButton setTitleColor:[UIColor blackColor]
                           forState:UIControlStateNormal];
    self.storeNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.storeNameButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.storeNameButton.titleLabel.font = XNFont(13);
    [self addSubview:self.storeNameButton];

}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.selectStoreGoodsButton.frame = CGRectMake(0, 0, 36, 30);
    
    self.storeNameButton.frame = CGRectMake(40, 0, XNWindowWidth-40, 30);

}

+ (CGFloat)getCartHeaderHeight{
    
    return 30;
}

//- (void)selectShopGoods:(UIButton *)btn{
//    
//    btn.selected = !btn.selected;
//}

@end
