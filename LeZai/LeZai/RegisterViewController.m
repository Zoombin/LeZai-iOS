//
//  RegisterViewController.m
//  LeZai
//
//  Created by 颜超 on 14-6-12.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIViewController+Hud.h"
#import "LZService.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"注册";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerButtonClick:(id)sender
{
    [[LZService shared] loginOrRegister:_accountTextField.text password:_passwordTextField.text type:0 withBlock:^(NSDictionary *result, NSError *error) {
        if ([result isKindOfClass:[NSDictionary class]] && result) {
            if ([result[@"Token"] length] > 0 && ![result[@"Token"] isEqualToString:@"false"]) {
                [self displayHUDTitle:nil message:@"注册成功请等待后台审核!"];
            } else {
                [self displayHUDTitle:nil message:@"注册失败!"];
            }
        }
        
    }];
}

@end
