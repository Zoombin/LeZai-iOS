//
//  LoginViewController.h
//  LeZai
//
//  Created by 颜超 on 14-6-13.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *accountTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIScrollView *loginScroll;
- (IBAction)loginButtonClick:(id)sender;
- (IBAction)registerButtonClick:(id)sender;
@end
