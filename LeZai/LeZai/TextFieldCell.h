//
//  TextFieldCell.h
//  LeZai
//
//  Created by 颜超 on 14-2-14.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@end
