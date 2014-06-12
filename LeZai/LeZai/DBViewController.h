//
//  DBViewController.h
//  LeZai
//
//  Created by 颜超 on 14-5-21.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *accountTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
- (IBAction)loginButtonClick:(id)sender;
- (IBAction)registerButtonClick:(id)sender;
@property (nonatomic, weak) IBOutlet UITableView *dbTableView;
@property (nonatomic, weak) IBOutlet UIScrollView *loginScroll;
- (IBAction)firstSegValueChanged:(id)sender;
@end
