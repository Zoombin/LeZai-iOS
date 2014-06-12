//
//  UploadImageViewController.m
//  LeZai
//
//  Created by 颜超 on 14-6-12.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "UploadViewController.h"

@interface UploadViewController ()

@end

@implementation UploadViewController

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
    [_imageButton setHidden:YES];
    [_messageTextView setHidden:YES];
    if (_type == PICK_ORDER) {
        self.title = @"确定提货";
        [_imageButton setHidden:NO];
    } else if (_type == SEND_ORDER) {
        [_imageButton setHidden:NO];
        self.title = @"确定收货";
    } else {
        [_messageTextView setHidden:NO];
        self.title = @"撤销订单";
    }
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)uploadImageButtonClick:(id)sender
{
    [self selectPhotoPicker];
}
- (IBAction)sumitButtonClick:(id)sender
{
    if (_type == CANCEL_ORDER) {
        
    } else {
        BOOL isPick = _type == PICK_ORDER;
        
    }
}

- (void)takePhoto
{
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        NSLog(@"模拟器不能照相!");
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary *)info
{
	UIImage* image = info[UIImagePickerControllerOriginalImage];
    image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.3)];
    [_imageButton setImage:image forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectPhotoPicker
{
    UIActionSheet* myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles: @"打开照相机", @"从相册获取",nil];
    [myActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
        case 1:  //打开本地相册
            [self LocalPhoto];
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
