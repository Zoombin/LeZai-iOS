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
#import "APService.H"

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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [_customButton.layer setCornerRadius:7.0];
    [_driverButton.layer setCornerRadius:7.0];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)driverButtonClick:(id)sender
{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [APService setTags:[NSSet setWithObject:I_AM_DRIVER] callbackSelector:nil object:nil];
    [[LZService shared] saveRole:I_AM_DRIVER];
    [appdelegate addDirverTabBar];
}

- (IBAction)customButtonClick:(id)sender
{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [APService setTags:[NSSet setWithObject:I_AM_CUSTOMER] callbackSelector:nil object:nil];
    [[LZService shared] saveRole:I_AM_CUSTOMER];
    [appdelegate addCustomerTabBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
