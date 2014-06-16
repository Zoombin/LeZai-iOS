//
//  AllOrderListViewController.m
//  LeZai
//
//  Created by 颜超 on 14-6-13.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "AllOrderListViewController.h"
#import "DBObject.h"
#import "DBDetailViewController.h"
#import "UIViewController+HUD.h"
#import "LZService.h"
#import "DBCell.h"
#import "AppDelegate.h"

@interface AllOrderListViewController ()

@end

@implementation AllOrderListViewController {
    NSMutableArray *resultInfo;
    int page;
    int count;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"所有订单";
        resultInfo = [NSMutableArray array];
        page = 1;
        count = 10;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"切换" style:UIBarButtonItemStyleBordered target:self action:@selector(signOut)];
    self.navigationItem.leftBarButtonItem = leftButton;
    // Do any additional setup after loading the view from its nib.
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
    [self loadAllOrderList];
}

- (void)loadAllOrderList
{
    [self displayHUD:@"加载中..."];
    [[LZService shared] orderListPage:page
                                count:count
                            WithBlock:^(NSArray *result, NSError *error) {
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
    page++;
    count++;
    [self loadAllOrderList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end
