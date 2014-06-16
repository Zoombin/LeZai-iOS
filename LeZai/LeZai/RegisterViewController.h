//
//  RegisterViewController.h
//  LeZai
//
//  Created by 颜超 on 14-6-12.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *accountTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UITextField *confirmTextField;
- (IBAction)registerButtonClick:(id)sender;
@end
