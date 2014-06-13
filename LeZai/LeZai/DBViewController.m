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

@interface DBViewController ()

@end

@implementation DBViewController {
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
    [_dbTableView setTableHeaderView:_segmentedControl2];
    [_dbTableView setFrame:CGRectMake(0, 0, 320, 548 - 44)];
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
    return 115;
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
