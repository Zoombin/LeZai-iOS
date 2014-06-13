//
//  DBViewController.h
//  LeZai
//
//  Created by 颜超 on 14-5-21.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *footView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl2;
@property (nonatomic, strong) IBOutlet UITableView *dbTableView;
- (IBAction)secondSegValueChanged:(id)sender;
- (IBAction)loadMoreButtonClick:(id)sender;

@end
