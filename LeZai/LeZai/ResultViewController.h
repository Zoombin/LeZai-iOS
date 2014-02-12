//
//  ResultViewController.h
//  LeZai
//
//  Created by 颜超 on 14-2-8.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *resultTableView;
@property (nonatomic, strong) NSString *beginCity;
@property (nonatomic, strong) NSString *endCity;
@property (nonatomic, strong) NSString *sendDate;
@property (nonatomic, strong) IBOutlet UIView *footView;
- (IBAction)loadMore:(id)sender;
@end
