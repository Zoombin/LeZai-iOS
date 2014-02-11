//
//  OrderViewController.m
//  LeZai
//
//  Created by 颜超 on 14-2-8.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "OrderViewController.h"
#import "LZService.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"订单查询";
//        {"Token":"acf7ef943fdeb3cbfed8dd0d8f584731","ClientKey":"12345","UserName":null,"Password":null,"ClientMode":"Android","OrderNo":null,"BeginCity":"北京市","EndCity":"苏州市","SendDate":"2014-2-11","OrderBy":"LM_PRICE ASC","StartRows":"1","RecordRows":"5"}
//        UIDevice *device = [UIDevice currentDevice];//创建设备对象
//        NSLog(@"%@",[[device identifierForVendor] UUIDString]); // 输出设备id
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
    //1310221000001
    [[LZService shared] searchOrderByOrderNO:_searchBar.text withBlock:^(NSString *result) {
        if (result) {
            [_resultTextView setText:result];
        }
    }];
    
//    订单编号 订单状态 订单评价 委托单位 收货单位 提货日期 送货日期 件数 毛重 体积 发车时间 运输线路 订单金额 结算方式 货物名称 货物种类 货物重量 货物体积 订单时间
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
