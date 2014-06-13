//
//  LoginViewController.m
//  LeZai
//
//  Created by 颜超 on 14-6-13.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UIViewController+HUD.h"
#import "LZService.h"
#import "AppDelegate.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"登录";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenAllKeyboard)];
    [_loginScroll addGestureRecognizer:tapGesture];
    // Do any additional setup after loading the view from its nib.
}

- (void)hidenAllKeyboard
{
    [_accountTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
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
    if ([_accountTextField.text areAllCharactersSpace]) {
        [self displayHUDTitle:nil message:@"请输入账号!"];
        return;
    }
    if ([_passwordTextField.text areAllCharactersSpace]) {
        [self displayHUDTitle:nil message:@"请输入密码!"];
        return;
    }
    [self displayHUD:@"登录中..."];
    [[LZService shared] loginOrRegister:_accountTextField.text
                               password:_passwordTextField.text
                                   type:1
                              withBlock:^(NSDictionary *result, NSError *error) {
                                  if (result && [result isKindOfClass:[NSDictionary class]]) {
                                      if ([result[@"Token"] length] > 0 && ![result[@"Token"] isEqualToString:@"false"]) {
                                          [self hideHUD:YES];
                                          [[LZService shared] saveUserToken:result[@"Token"]];
                                          [self pushToMain];
                                      } else {
                                          [self displayHUDTitle:nil message:@"登录失败"];
                                      }
                                  }
                              }];
}

- (void)pushToMain
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate addDirverTabBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
