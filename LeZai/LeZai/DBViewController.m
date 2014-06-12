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
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"短驳订单";
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
 [[LZService shared] loginOrRegister:_accountTextField.text password:_passwordTextField.text type:1 withBlock:^(NSDictionary *result, NSError *error) {
     NSLog(@"%@", result);
     if (result && [result isKindOfClass:[NSDictionary class]]) {
         if ([result[@"Token"] length] > 0 && ![result[@"Token"] isEqualToString:@"false"]) {
             [[LZService shared] saveUserToken:result[@"Token"]];
             [self showBoListView];
         }
     }
 }];
}

- (void)loadAllOrderList
{
    [self displayHUD:@"加载中..."];
    [[LZService shared] orderListPage:1 count:10 WithBlock:^(NSArray *result, NSError *error) {
        NSLog(@"%@", result);
        [self hideHUD:YES];
        if ([result count] > 0) {
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
   [[LZService shared] getOrderList:ORDER_ORDERING withBlock:^(NSArray *result, NSError *error) {
       NSLog(@"%@", result);
       [self hideHUD:YES];
       if ([result count] > 0) {
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
    [[LZService shared] getOrderList:ORDER_PICK withBlock:^(NSArray *result, NSError *error) {
        NSLog(@"%@", result);
        [self hideHUD:YES];
        if ([result count] > 0) {
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
    UISegmentedControl *control = (UISegmentedControl *)sender;
    int type = 0;
    
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
    [self displayHUD:@"加载中..."];
    [[LZService shared] getOrderList:type withBlock:^(NSArray *result, NSError *error) {
        NSLog(@"%@", result);
        [self hideHUD:YES];
        if ([result count] > 0) {
            resultInfo = [DBObject createDBObjectsWithArray:result];
            [_dbTableView reloadData];
        } else {
            resultInfo = nil;
            [_dbTableView reloadData];
        }
    }];
}

@end
