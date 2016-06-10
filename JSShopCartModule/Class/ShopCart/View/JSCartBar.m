//
//  JSCartBar.m
//  JSShopCartModule
//
//  Created by 乔同新 on 16/6/9.
//  Copyright © 2016年 乔同新. All rights reserved.
//

static NSInteger const BalanceButtonTag = 120;

static NSInteger const DeleteButtonTag = 121;

static NSInteger const SelectButtonTag = 122;

#import "JSCartBar.h"

@interface UIImage (JS)

+ (UIImage *)imageWithColor:(UIColor *)color ;

@end

@implementation UIImage (JS)

+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end

@interface JSCartBar ()

@end

@implementation JSCartBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBarUI];
    }
    return self;
}

- (void)setBarUI{
    
    self.backgroundColor = [UIColor clearColor];
    /* 背景 */
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effectView.userInteractionEnabled = NO;
    effectView.frame = self.bounds;
    [self addSubview:effectView];
    
    CGFloat wd = XNWindowWidth*2/7;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XNWindowWidth, 0.5)];
    lineView.backgroundColor  = XNColor(210, 210, 210, 1);
    [self addSubview:lineView];
    /* 结算 */
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    [button setTitle:@"结算" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(XNWindowWidth-wd, 0, wd, self.frame.size.height)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    button.enabled = NO;
    button.tag = BalanceButtonTag;
    [self addSubview:button];
    _balanceButton = button;
    /* 删除 */
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    [button1 setTitle:@"删除" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [button1 setFrame:CGRectMake(XNWindowWidth-wd, 0, wd, self.frame.size.height)];
    button1.enabled = NO;
    button1.hidden = YES;
    button1.tag = DeleteButtonTag;
    [self addSubview:button1];
    _deleteButton = button1;
    /* 全选 */
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setTitle:@"全选"
             forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blackColor]
                  forState:UIControlStateNormal];
    [button3 setImage:[UIImage imageNamed:@"xn_circle_normal"]
             forState:UIControlStateNormal];
    [button3 setImage:[UIImage imageNamed:@"xn_circle_select"]
             forState:UIControlStateSelected];
    [button3 setFrame:CGRectMake(0, 0, 78, self.frame.size.height)];
    [button3 setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    button3.tag = SelectButtonTag;
    [self addSubview:button3];
    _selectAllButton = button3;
    /* 价格 */
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(wd, 0, XNWindowWidth-wd*2-5, self.frame.size.height)];
    label1.text = [NSString stringWithFormat:@"总计￥:%@",@(00.00)];
    label1.textColor = [UIColor blackColor];
    label1.font = XNFont(15);
    label1.textAlignment = NSTextAlignmentRight;
    [self addSubview:label1];
    _allMoneyLabel = label1;
    
    /* assign value */
    WEAK
    [RACObserve(self, money) subscribeNext:^(NSNumber *x) {
        STRONG
        self.allMoneyLabel.text = [NSString stringWithFormat:@"总计￥:%.2f",x.floatValue];
    }];
    
    /*  RAC BLIND  */
    RACSignal *comBineSignal = [RACSignal combineLatest:@[RACObserve(self, money)]
                                                 reduce:^id(NSNumber *moeny){
                                                     if (moeny.floatValue == 0) {
                                                         self.selectAllButton.selected = NO;
                                                     }
                                                     return @(moeny.floatValue>0);
                                                 }];

    RAC(self.balanceButton,enabled) = comBineSignal;
    RAC(self.deleteButton,enabled) = comBineSignal;
    
    [RACObserve(self, isNormalState) subscribeNext:^(NSNumber *x) {
        STRONG
        BOOL isNormal =  x.boolValue;
        self.balanceButton.hidden = !isNormal;
        self.allMoneyLabel.hidden = !isNormal;
        self.deleteButton.hidden = isNormal;
    }];
}


@end
