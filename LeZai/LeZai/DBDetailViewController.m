//
//  DBDetailViewController.m
//  LeZai
//
//  Created by 颜超 on 14-5-24.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "DBDetailViewController.h"
#import "LZService.h"
#import "UIViewController+HUD.h"
#import "DBObject.h"
#import "UploadViewController.h"

@interface DBDetailViewController ()

@end

@implementation DBDetailViewController {
    DBObject *dbInfo;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"订单详情";
    [self loadOrderInfo];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadOrderInfo
{
    [self displayHUD:@"加载中..."];
    [[LZService shared] orderInfo:_orderId withBlock:^(NSArray *result, NSError *error) {
        NSLog(@"%@", result);
        [self hideHUD:YES];
        if ([result count] > 0) {
            dbInfo = [DBObject createDBObjectsWithArray:result][0];
            _startLocationLabel.text = dbInfo.departure;
            _endLocationLabel.text = dbInfo.destination;
            _finishDateLabel.text = dbInfo.finishDate;
            _priceLabel.text = [NSString stringWithFormat:@"%@", dbInfo.price];
            _submitLabel.text = dbInfo.submitDate;
            _statusLabel.text = dbInfo.status;
            dbInfo.orderInfo = [dbInfo.orderInfo stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];
            [_goodInfoTextView setText:dbInfo.orderInfo];
        }
        
    }];
}

- (void)orderButtonClick:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入金额"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        NSString *price = [alertView textFieldAtIndex:0].text;
        if ([price length] > 0) {
            [[LZService shared] addOrder:dbInfo.oid price:price withBlock:^(NSDictionary *result, NSError *error) {
                NSLog(@"%@", result);
            }];
        } else {
            [self displayHUDTitle:nil message:@"请输入金额"];
        }
    }
}

- (IBAction)pickButtonClick:(id)sender
{
    UploadViewController *viewCtrl = [[UploadViewController alloc] initWithNibName:@"UploadViewController" bundle:nil];
    viewCtrl.type = PICK_ORDER;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (IBAction)sendButtonClick:(id)sender
{
    UploadViewController *viewCtrl = [[UploadViewController alloc] initWithNibName:@"UploadViewController" bundle:nil];
    viewCtrl.type = SEND_ORDER;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (IBAction)cancelButtonClick:(id)sender
{
    UploadViewController *viewCtrl = [[UploadViewController alloc] initWithNibName:@"UploadViewController" bundle:nil];
    viewCtrl.type = CANCEL_ORDER;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
