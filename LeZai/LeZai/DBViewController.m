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
    NSArray *resultInfo;
    int page;
    int count;
    int type;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"短驳订单";
        page = 1;
        count = 10;
        type = ORDER_PICK;
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"order_search_hl"] withFinishedUnselectedImage:[UIImage imageNamed:@"order_search"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[LZService shared] userToken]) {
        _loginScroll.hidden = YES;
        [self loadAllOrderList];
    }
    self.navigationItem.rightBarButtonItem = nil;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenAllKeyboard)];
    [_loginScroll addGestureRecognizer:tapGesture];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerButtonClick:(id)sender
{
    RegisterViewController *viewCtrl = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (IBAction)loginButtonClick:(id)sender
{
    [self hidenAllKeyboard];
    [self displayHUD:@"登录中..."];
    [[LZService shared] loginOrRegister:_accountTextField.text
                               password:_passwordTextField.text
                                   type:1
                              withBlock:^(NSDictionary *result, NSError *error) {
                                  if (result && [result isKindOfClass:[NSDictionary class]]) {
                                      if ([result[@"Token"] length] > 0 && ![result[@"Token"] isEqualToString:@"false"]) {
                                          [self hideHUD:YES];
                                          [[LZService shared] saveUserToken:result[@"Token"]];
                                          [self showBoListView];
                                      } else {
                                          [self displayHUDTitle:nil message:@"登录失败"];
                                      }
                                  }
                              }];
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
                                    resultInfo = [DBObject createDBObjectsWithArray:result];
                                    [_dbTableView reloadData];
                                } else {
                                    resultInfo = nil;
                                    [_dbTableView reloadData];
                                }
                            }];
}

- (void)loadOrderingList
{
    [self displayHUD:@"加载中..."];
    [[LZService shared] getOrderList:ORDER_ORDERING
                                page:1
                               count:10
                           withBlock:^(NSArray *result, NSError *error) {
                               [self hideHUD:YES];
                               if ([result count] > 0) {
                                   if ([result count] < count) {
                                       [_dbTableView setTableFooterView:nil];
                                   } else {
                                       [_dbTableView setTableFooterView:_footView];
                                   }
                                   resultInfo = [DBObject createDBObjectsWithArray:result];
                                   [_dbTableView reloadData];
                               } else {
                                   resultInfo = nil;
                                   [_dbTableView reloadData];
                               }
                           }];
}

- (void)loadOrderedList
{
    [self displayHUD:@"加载中..."];
    [[LZService shared] getOrderList:type
                                page:1
                               count:10
                           withBlock:^(NSArray *result, NSError *error) {
                               NSLog(@"%@", result);
                               [self hideHUD:YES];
                               if ([result count] > 0) {
                                   if ([result count] < count) {
                                       [_dbTableView setTableFooterView:nil];
                                   } else {
                                       [_dbTableView setTableFooterView:_footView];
                                   }
                                   resultInfo = [DBObject createDBObjectsWithArray:result];
                                   [_dbTableView reloadData];
                               } else {
                                   resultInfo = nil;
                                   [_dbTableView reloadData];
                               }
                           }];
}

- (void)hidenAllKeyboard
{
    [_accountTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (void)showBoListView
{
    [self hidenAllKeyboard];
    _loginScroll.hidden = YES;
    [self loadAllOrderList];
}

- (IBAction)loadMoreButtonClick:(id)sender
{
    if (_segmentedControl.selectedSegmentIndex == 0) {
        [self loadAllOrderList];
    } else if (_segmentedControl.selectedSegmentIndex == 1) {
        [self loadOrderingList];
    } else if (_segmentedControl.selectedSegmentIndex == 2) {
        [self loadOrderedList];
    }
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
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (IBAction)firstSegValueChanged:(id)sender
{
    page = 1;
    UISegmentedControl *control = (UISegmentedControl *)sender;
    [_dbTableView setTableHeaderView:nil];
    if (control.selectedSegmentIndex == 0) {
        NSLog(@"1");
        [self loadAllOrderList];
    } else if (control.selectedSegmentIndex == 1) {
        NSLog(@"2");
        [self loadOrderingList];
    } else {
        NSLog(@"3");
        [self loadOrderedList];
        [_dbTableView setTableHeaderView:_segmentedControl];
    }
}

- (IBAction)secondSegValueChanged:(id)sender
{
    page = 1;
    UISegmentedControl *control = (UISegmentedControl *)sender;
    
    if (control.selectedSegmentIndex == 0) {
        NSLog(@"1");
        type = ORDER_PICK;
    } else if (control.selectedSegmentIndex == 1) {
        NSLog(@"2");
        type = ORDER_SEND;
    } else if (control.selectedSegmentIndex == 2) {
        NSLog(@"3");
        type = ORDER_FINISH;
    }  else {
        NSLog(@"4");
        type = ORDER_CANCEL;
    }
    [self loadOrderedList];
}

@end
