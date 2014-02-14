//
//  OrderViewController.m
//  LeZai
//
//  Created by 颜超 on 14-2-8.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "OrderViewController.h"
#import "LZService.h"
#import "UIViewController+HUD.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"订单状态跟踪";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyBoard)];
    [self.view addGestureRecognizer:tapGesture];
    // Do any additional setup after loading the view from its nib.
}

- (void)hidenKeyBoard
{
    [_searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [_searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [_searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //1310221000001
    [self searchOrder:nil];
}

- (IBAction)searchOrder:(id)sender
{
    [self hidenKeyBoard];
    [self displayHUD:@"加载中..."];
    [[LZService shared] searchOrderByOrderNO:_searchBar.text withBlock:^(NSString *result) {
        if (result) {
            [_resultTextView setText:result];
            [self hideHUD:YES];
        } else {
            [self displayHUDTitle:nil message:@"未获取到相关信息" duration:1.0];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
