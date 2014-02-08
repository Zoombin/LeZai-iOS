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
@end
