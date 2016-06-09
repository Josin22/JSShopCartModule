//
//  JSCartCell.m
//  JSShopCartModule
//
//  Created by 乔同新 on 16/6/9.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "JSCartCell.h"
#import "JSNummberCount.h"
#import "JSCartModel.h"

@interface JSCartCell ()

@property (weak, nonatomic) IBOutlet UILabel        *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel        *GoodsPricesLabel;
@property (weak, nonatomic) IBOutlet UIImageView    *goodsImageView;

@end

@implementation JSCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setModel:(JSCartModel *)model{
    
    self.goodsNameLabel.text             = model.p_name;
    self.GoodsPricesLabel.text           = [NSString stringWithFormat:@"￥%.2f",model.p_price];
    self.nummberCount.totalNum           = model.p_stock;
    self.nummberCount.currentCountNumber = model.p_quantity;
    self.selectShopGoodsButton.selected  = model.isSelect;
//    [self.goodsImageView ]
}

+ (CGFloat)getCartCellHeight{
    
    return 100;
}

@end
