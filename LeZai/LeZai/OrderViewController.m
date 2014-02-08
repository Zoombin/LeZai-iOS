//
//  OrderViewController.m
//  LeZai
//
//  Created by 颜超 on 14-2-8.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "OrderViewController.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"订单查询";
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
    NSLog(@"搜索订单号为: %@", _searchBar.text);
    [_resultTextView setText:[NSString stringWithFormat:@"订单编号:%@ \n订单状态:正在派件 \n订单位置: 上海->苏州->无锡->常州->镇江->南京", _searchBar.text]];
    
//    订单编号 订单状态 订单评价 委托单位 收货单位 提货日期 送货日期 件数 毛重 体积 发车时间 运输线路 订单金额 结算方式 货物名称 货物种类 货物重量 货物体积 订单时间
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
