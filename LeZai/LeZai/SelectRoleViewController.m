//
//  SelectRoleViewController.m
//  LeZai
//
//  Created by 颜超 on 14-6-13.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "SelectRoleViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "LZService.h"

@interface SelectRoleViewController ()

@end

#define ALERT_TAG_DRIVER      1
#define ALERT_TAG_CUSTOMER    2


@implementation SelectRoleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"选择用户类型";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_customButton.layer setCornerRadius:7.0];
    [_driverButton.layer setCornerRadius:7.0];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)driverButtonClick:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"确定选择司机吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = ALERT_TAG_DRIVER;
    [alertView show];
}

- (IBAction)customButtonClick:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"确定选择客户吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = ALERT_TAG_CUSTOMER;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex == buttonIndex) {
        return;
    }
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (alertView.tag == ALERT_TAG_CUSTOMER) {
        [[LZService shared] saveRole:I_AM_CUSTOMER];
        [appdelegate addCustomerTabBar];
    } else {
        [[LZService shared] saveRole:I_AM_DRIVER];
        [appdelegate addDirverTabBar];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
