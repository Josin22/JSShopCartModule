//
//  JSCartUIService.h
//  JSShopCartModule
//
//  Created by 乔同新 on 16/6/9.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSCartViewModel;

@interface JSCartUIService : NSObject<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) JSCartViewModel *viewModel;

@end
