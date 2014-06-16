//
//  OrderViewController.h
//  LeZai
//
//  Created by 颜超 on 14-2-8.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UITextView *resultTextView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIButton *searchButton;
@property (nonatomic, weak) IBOutlet UITableView *resultTableView;
- (IBAction)hidenKeyBoard:(id)sender;
- (IBAction)searchOrder:(id)sender;
@end
