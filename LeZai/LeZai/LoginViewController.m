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
#import <QuartzCore/QuartzCore.h>
#import "LZService.h"
#import "AppDelegate.h"
#import "APService.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"切换" style:UIBarButtonItemStyleBordered target:self action:@selector(signOut)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleBordered target:self action:@selector(registerButtonClick:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [_loginButton.layer setCornerRadius:5.0];
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenAllKeyboard)];
//    [_loginScroll addGestureRecognizer:tapGesture];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[LZService shared] userAccount] && [[LZService shared] userPassword]) {
        _accountTextField.text = [[LZService shared] userAccount];
        _passwordTextField.text = [[LZService shared] userPassword];
    }
    [_accountTextField becomeFirstResponder];
}

- (void)signOut
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定切换用户身份吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate changeRole];
    }
}

- (void)hidenAllKeyboard
{
    [_accountTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _passwordTextField) {
        [self loginButtonClick:nil];
    }
    return YES;
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
                                          [[LZService shared] saveAccount:_accountTextField.text password:_passwordTextField.text];
                                          [APService setTags:[NSSet setWithObject:I_AM_DRIVER] alias:result[@"Token"] callbackSelector:nil target:self];
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
