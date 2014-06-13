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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadOrderInfo];
}

- (void)loadOrderInfo
{
    [self displayHUD:@"加载中..."];
    [[LZService shared] orderInfo:_orderId withBlock:^(NSArray *result, NSError *error) {
        [self hideHUD:YES];
        if ([result count] > 0) {
            dbInfo = [DBObject createDBObjectsWithArray:result][0];
            _startLocationLabel.text = dbInfo.departure;
            _endLocationLabel.text = dbInfo.destination;
            _finishDateLabel.text = dbInfo.finishDate;
            _priceLabel.text = [NSString stringWithFormat:@"%@", dbInfo.price];
            _submitLabel.text = dbInfo.submitDate;
            _statusLabel.text = dbInfo.statusName;
            if (_orderPrice) {
                [_orderPriceLabel setHidden:NO];
                _orderPriceLabel.text = [NSString stringWithFormat:@"抢单金额:  %@", _orderPrice];
            }
            NSArray *goodsArray = [dbInfo.orderInfo componentsSeparatedByString:@"|"];
            NSMutableString *goodsString = [@"" mutableCopy];
            for (int i = 0; i < [goodsArray count]; i++) {
                NSArray *values = [goodsArray[i] componentsSeparatedByString:@","];
                for (int j = 0; j < [values count]; j ++) {
                    if (j == 0) {
                        NSString *goodsName = [NSString stringWithFormat:@"品名:%@ ", values[j]];
                        [goodsString appendString:goodsName];
                    } else if (j == 1) {
                        NSString *typeName = [NSString stringWithFormat:@"包装:%@ ", values[j]];
                        [goodsString appendString:typeName];
                    } else if (j == 2) {
                        NSString *timesName = [NSString stringWithFormat:@"\n件数:%@ ", values[j]];
                        [goodsString appendString:timesName];
                    } else if (j == 3) {
                        NSString *weightName = [NSString stringWithFormat:@"毛重:%@ ", values[j]];
                        [goodsString appendString:weightName];
                    } else if (j == 4) {
                        NSString *volumeName = [NSString stringWithFormat:@"体积:%@ \n", values[j]];
                        [goodsString appendString:volumeName];
                    }
                }
            }
            [_goodInfoTextView setText:goodsString];
            _orderButton.hidden = YES;
            _pickButton.hidden = YES;
            _sendButton.hidden = YES;
            _cancelButton.hidden = YES;
            if ([dbInfo.status isEqualToString:@"B"]) {
                _orderButton.hidden = NO;
            } else if([dbInfo.status isEqualToString:@"C"] && ![_listState isEqualToString:@"E"]) {
                _pickButton.hidden = NO;
                _cancelButton.hidden = NO;
            } else if([dbInfo.status isEqualToString:@"E"]) {
                _sendButton.hidden = NO;
            } else if([dbInfo.status isEqualToString:@"F"]) {
            }
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
                if ([result[@"OrdState"] integerValue] == 1) {
                    NSLog(@"成功");
                    [self displayHUDTitle:nil message:@"抢单成功!"];
                } else if ([result[@"OrdState"] integerValue] == 0){
                    [self displayHUDTitle:nil message:@"抢单失败!"];
                } else if ([result[@"OrdState"] integerValue] == 2){
                    [self displayHUDTitle:nil message:@"此单已接单成功不允许再竞单!"];
                } else {
                    [self displayHUDTitle:nil message:@"抢单失败!"];
                }
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
    viewCtrl.oid = dbInfo.oid;
    viewCtrl.orderNo = dbInfo.oidNo;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (IBAction)sendButtonClick:(id)sender
{
    UploadViewController *viewCtrl = [[UploadViewController alloc] initWithNibName:@"UploadViewController" bundle:nil];
    viewCtrl.type = SEND_ORDER;
    viewCtrl.oid = dbInfo.oid;
    viewCtrl.orderNo = dbInfo.oidNo;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (IBAction)cancelButtonClick:(id)sender
{
    UploadViewController *viewCtrl = [[UploadViewController alloc] initWithNibName:@"UploadViewController" bundle:nil];
    viewCtrl.type = CANCEL_ORDER;
    viewCtrl.oid = dbInfo.oid;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
