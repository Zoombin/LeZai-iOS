//
//  CarpoolingViewController.m
//  LeZai
//
//  Created by 颜超 on 14-2-8.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "CarpoolingViewController.h"
#import "ResultViewController.h"

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
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [_scrollView addGestureRecognizer:tapGesture];
    // Do any additional setup after loading the view from its nib.
}

- (void)hideKeyBoard
{
    [_startLocationTextField resignFirstResponder];
    [_endLocationTextField resignFirstResponder];
}

- (IBAction)showDatePicker:(id)sender
{
    [_datePickerView setHidden:NO];
}

- (IBAction)hidenDatePicker:(id)sender
{
    [_datePickerView setHidden:YES];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [_dateSelectButton setTitle:[dateFormatter stringFromDate:_datePicker.date] forState:UIControlStateNormal];
}

- (IBAction)search:(id)sender
{
    [self hideKeyBoard];
 
    ResultViewController *resultViewController = [[ResultViewController alloc] init];
    [resultViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:resultViewController animated:YES];
}

@end
