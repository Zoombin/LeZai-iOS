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
#import <QuartzCore/QuartzCore.h>

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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_startLocationTextField.layer setCornerRadius:CORNER_RADIUS];
    [_startLocationTextField.layer setBorderWidth:BORDER_WIDTH];
    [_startLocationTextField.layer setBorderColor:BORDER_COLOR];
    
    [_endLocationTextField.layer setCornerRadius:CORNER_RADIUS];
    [_endLocationTextField.layer setBorderWidth:BORDER_WIDTH];
    [_endLocationTextField.layer setBorderColor:BORDER_COLOR];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStyleBordered target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [_dateSelectButton setTitle:[dateFormatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [_scrollView addGestureRecognizer:tapGesture];
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

- (void)datePickerValueChanged:(id)sender
{
    
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

- (void)search
{
    [self hideKeyBoard];
    if ([_startLocationTextField.text areAllCharactersSpace]) {
        [self displayHUDTitle:nil message:@"请输入始发地!"];
        return;
    }
    if ([_endLocationTextField.text areAllCharactersSpace]) {
        [self displayHUDTitle:nil message:@"请输入目的地!"];
        return;
    }
    ResultViewController *resultViewController = [[ResultViewController alloc] init];
    resultViewController.beginCity = _startLocationTextField.text;
    resultViewController.endCity = _endLocationTextField.text;
    resultViewController.sendDate = _dateSelectButton.titleLabel.text;
    [resultViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:resultViewController animated:YES];
}

@end
