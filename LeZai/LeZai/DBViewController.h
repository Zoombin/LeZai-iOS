//
//  DBViewController.h
//  LeZai
//
//  Created by 颜超 on 14-5-21.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *dbTableView;
@end
