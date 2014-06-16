//
//  AllOrderListViewController.h
//  LeZai
//
//  Created by 颜超 on 14-6-13.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllOrderListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *dbTableView;
@property (nonatomic, strong) IBOutlet UIView *footView;
- (IBAction)loadMoreButtonClick:(id)sender;
@end
