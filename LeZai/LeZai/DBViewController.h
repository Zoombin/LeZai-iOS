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
@property (nonatomic, strong) IBOutlet UIView *footView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) IBOutlet UITableView *dbTableView;
@property (nonatomic, weak) IBOutlet UIScrollView *loginScroll;
- (IBAction)firstSegValueChanged:(id)sender;
- (IBAction)secondSegValueChanged:(id)sender;
- (IBAction)loginButtonClick:(id)sender;
- (IBAction)registerButtonClick:(id)sender;
- (IBAction)loadMoreButtonClick:(id)sender;

@end
