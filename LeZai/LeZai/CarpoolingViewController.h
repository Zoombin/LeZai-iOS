//
//  CarpoolingViewController.h
//  LeZai
//
//  Created by 颜超 on 14-2-8.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarpoolingViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *datePickerView;
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, weak) IBOutlet UITextField *startLocationTextField;
@property (nonatomic, weak) IBOutlet UITextField *endLocationTextField;
@property (nonatomic, weak) IBOutlet UIButton *dateSelectButton;


- (IBAction)showDatePicker:(id)sender;
- (IBAction)hidenDatePicker:(id)sender;
- (void)search;
@end
