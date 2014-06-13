//
//  UploadViewController.h
//  LeZai
//
//  Created by 颜超 on 14-6-12.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PICK_ORDER     1
#define SEND_ORDER     2
#define CANCEL_ORDER   3

@interface UploadViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString *oid;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, weak) IBOutlet UIButton *imageButton;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UITextView *messageTextView;
@property (nonatomic, strong) UIImage *image;
- (IBAction)uploadImageButtonClick:(id)sender;
- (IBAction)sumitButtonClick:(id)sender;
@end
