//
//  DBViewController.m
//  LeZai
//
//  Created by 颜超 on 14-5-21.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "DBViewController.h"
#import "DBCell.h"
#import "LZService.h"
#import "DBObject.h"
#import "RegisterViewController.h"
#import "DBDetailViewController.h"
#import "UIViewController+Hud.h"
#import "AppDelegate.h"

@interface DBViewController ()

@end

@implementation DBViewController {
    UIRefreshControl *refreshControl;
    NSMutableArray *resultInfo;
    int page;
    int count;
    int type;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"抢单成功";
        page = 1;
        count = 10;
        type = ORDER_PICK;
        resultInfo = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"切换" style:UIBarButtonItemStyleBordered target:self action:@selector(signOut)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    [_dbTableView setTableHeaderView:_segmentedControl2];
    [_dbTableView setFrame:CGRectMake(0, 0, 320, 548 - 44)];
    
     refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, _dbTableView.frame.size.width, 100.0f)];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
	[_dbTableView.tableHeaderView addSubview:refreshControl];
}

- (void)refreshData
{
    page = 1;
    [resultInfo removeAllObjects];
    [_dbTableView reloadData];
    [refreshControl beginRefreshing];
    [self loadOrderedList];
}

- (void)signOut
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定切换用户身份吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        [[LZService shared] signOut];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate changeRole];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    page = 1;
    [resultInfo removeAllObjects];
    [_dbTableView reloadData];
    [self loadOrderedList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadOrderedList
{
    [self displayHUD:@"加载中..."];
    [[LZService shared] getOrderList:type
                                page:page
                               count:count
                           withBlock:^(NSArray *result, NSError *error) {
                               [self hideHUD:YES];
                               [refreshControl endRefreshing];
                               if ([result count] > 0) {
                                   if ([result count] < count) {
                                       [_dbTableView setTableFooterView:nil];
                                   } else {
                                       [_dbTableView setTableFooterView:_footView];
                                   }
                                   [resultInfo addObjectsFromArray:[DBObject createDBObjectsWithArray:result]];
                                   [_dbTableView reloadData];
                               } else {
                                   [resultInfo removeAllObjects];
                                   [_dbTableView reloadData];
                               }
                           }];
}

- (IBAction)loadMoreButtonClick:(id)sender
{
    page ++;
    [self loadOrderedList];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DBCell height];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resultInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    DBCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"DBCell" owner:self options: nil];
        cell = [nib objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setDuanBo:resultInfo[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBObject *object = resultInfo[indexPath.row];
    DBDetailViewController *viewCtrl = [[DBDetailViewController alloc] initWithNibName:@"DBDetailViewController" bundle:nil];
    viewCtrl.orderId = object.oid;
    viewCtrl.orderPrice = object.orderPrice;
    viewCtrl.hidesBottomBarWhenPushed = YES;
    viewCtrl.listState = object.listState;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (IBAction)secondSegValueChanged:(id)sender
{
    page = 1;
    [resultInfo removeAllObjects];
    [_dbTableView reloadData];
    [_dbTableView setTableFooterView:nil];
    UISegmentedControl *control = (UISegmentedControl *)sender;
    
    if (control.selectedSegmentIndex == 0) {
        type = ORDER_PICK;
    } else if (control.selectedSegmentIndex == 1) {
        type = ORDER_SEND;
    } else if (control.selectedSegmentIndex == 2) {
        type = ORDER_FINISH;
    }  else {
        type = ORDER_CANCEL;
    }
    [self loadOrderedList];
}

@end
