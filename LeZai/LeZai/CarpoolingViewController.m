//
//  CarpoolingViewController.m
//  LeZai
//
//  Created by 颜超 on 14-2-8.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "CarpoolingViewController.h"
#import "ResultViewController.h"
#import "LZService.h"
#import "UIViewController+HUD.h"
#import "NSString+ZBUtilites.h"
#import "LZService.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

#define CORNER_RADIUS 4
#define BORDER_WIDTH 0.5
#define BORDER_COLOR [UIColor grayColor].CGColor

@implementation CarpoolingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"拼车查询";
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"pc_search_hl"] withFinishedUnselectedImage:[UIImage imageNamed:@"pc_search"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"切换" style:UIBarButtonItemStyleBordered target:self action:@selector(signOut)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    NSInteger offset = 206;
    [_datePickerView setFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame) - offset, 320, 206)];
    [self.view addSubview:_datePickerView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [_scrollView addGestureRecognizer:tapGesture];
    
    if ([[LZService shared] startLocation]) {
        _startLocationTextField.text = [[LZService shared] startLocation];
    }
    if ([[LZService shared] endLocation]) {
        _endLocationTextField.text = [[LZService shared] endLocation];
    }
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

- (void)hideKeyBoard
{
    [_startLocationTextField resignFirstResponder];
    [_endLocationTextField resignFirstResponder];
}

- (IBAction)showDatePicker:(id)sender
{
    [self hideKeyBoard];
    [_datePickerView setHidden:NO];
}

- (IBAction)hidenDatePicker:(id)sender
{
    [_datePickerView setHidden:YES];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [_dateSelectButton setTitle:[dateFormatter stringFromDate:_datePicker.date] forState:UIControlStateNormal];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_datePickerView setHidden:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _startLocationTextField) {
        [_endLocationTextField becomeFirstResponder];
    } else if (textField == _endLocationTextField) {
        [self search];
    }
    return YES;
}

- (IBAction)searchButtonClick:(id)sender
{
    [self hideKeyBoard];
    if ([_startLocationTextField.text length] > 0) {
        [[LZService shared] saveStartLocation:_startLocationTextField.text];
    }
    if ([_endLocationTextField.text length] > 0) {
        [[LZService shared] saveEndLocation:_endLocationTextField.text];
    }
    ResultViewController *resultViewController = [[ResultViewController alloc] init];
    resultViewController.beginCity = _startLocationTextField.text;
    resultViewController.endCity = _endLocationTextField.text;
    resultViewController.sendDate = _dateSelectButton.titleLabel.text;
    [resultViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:resultViewController animated:YES];
}

@end
