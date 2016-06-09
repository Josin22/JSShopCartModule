//
//  JSCartViewController.m
//  JSShopCartModule
//
//  Created by 乔同新 on 16/6/9.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "JSCartViewController.h"
#import "JSCartUIService.h"
#import "JSCartViewModel.h"
#import "JSCartBar.h"


@interface JSCartViewController ()

@property (nonatomic, strong) JSCartUIService *service;

@property (nonatomic, strong) JSCartViewModel *viewModel;

@property (nonatomic, strong) UITableView     *cartTableView;

@property (nonatomic, strong) JSCartBar       *cartBar;

@end

@implementation JSCartViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.viewModel getData];
    [self.cartTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.title = @"购物车";
    [self.view addSubview:self.cartTableView];
    [self.view addSubview:self.cartBar];
    
    /* RAC  */
    //全选
    [[self.cartBar.selectAllButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        x.selected = !x.selected;
        [self.viewModel selectAll:x.selected];
    }];
    //删除
    [[self.cartBar.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        
    }];
    //结算
    [[self.cartBar.balanceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        
    }];
    /* 观察价格属性 */
    WEAK
    [RACObserve(self.viewModel, allPrices) subscribeNext:^(NSNumber *x) {
        STRONG
        self.cartBar.money = x.floatValue;
    }];
    
    /* 全选 状态 */
    RAC(self.cartBar.selectAllButton,selected) = RACObserve(self.viewModel, isSelectAll);
}


#pragma mark - lazy load

- (JSCartViewModel *)viewModel{
    
    if (!_viewModel) {
        _viewModel = [[JSCartViewModel alloc] init];
        _viewModel.cartVC = self;
        _viewModel.cartTableView  = self.cartTableView;
    }
    return _viewModel;
}


- (JSCartUIService *)service{
    
    if (!_service) {
        _service = [[JSCartUIService alloc] init];
        _service.viewModel = self.viewModel;
    }
    return _service;
}


- (UITableView *)cartTableView{
    
    if (!_cartTableView) {
        
        _cartTableView = [[UITableView alloc] initWithFrame:self.view.frame
                                                      style:UITableViewStyleGrouped];
        [_cartTableView registerNib:[UINib nibWithNibName:@"JSCartCell" bundle:nil]
             forCellReuseIdentifier:@"JSCartCell"];
        [_cartTableView registerClass:NSClassFromString(@"JSCartFooterView") forHeaderFooterViewReuseIdentifier:@"JSCartFooterView"];
        [_cartTableView registerClass:NSClassFromString(@"JSCartHeaderView") forHeaderFooterViewReuseIdentifier:@"JSCartHeaderView"];
        _cartTableView.dataSource = self.service;
        _cartTableView.delegate   = self.service;
        _cartTableView.backgroundColor = XNColor(240, 240, 240, 1);
        _cartTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XNWindowWidth, 50)];
    }
    return _cartTableView;
}

- (JSCartBar *)cartBar{
    
    if (!_cartBar) {
        _cartBar = [[JSCartBar alloc] initWithFrame:CGRectMake(0, XNWindowHeight-50, XNWindowWidth, 50)];
    }
    return _cartBar;
}

@end
