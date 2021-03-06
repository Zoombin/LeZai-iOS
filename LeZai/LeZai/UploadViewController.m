//
//  UploadImageViewController.m
//  LeZai
//
//  Created by 颜超 on 14-6-12.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "UploadViewController.h"
#import "UIViewController+Hud.h"
#import "LZService.h"

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
    [_messageTextView.layer setCornerRadius:7.0];
    [_messageTextView.layer setBorderColor:[UIColor grayColor].CGColor];
    [_messageTextView.layer setBorderWidth:.5];
    
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_imageButton setHidden:YES];
    [_imageView setHidden:YES];
    [_boxImageView setHidden:YES];
    [_messageTextView setHidden:YES];
    if (_type == PICK_ORDER) {
        self.title = @"确定提货";
        [_imageView setHidden:NO];
        [_boxImageView setHidden:NO];
        [_imageButton setHidden:NO];
    } else if (_type == SEND_ORDER) {
        [_imageView setHidden:NO];
        [_boxImageView setHidden:NO];
        [_imageButton setHidden:NO];
        self.title = @"确定收货";
    } else {
        [_messageTextView setHidden:NO];
        self.title = @"撤销订单";
    }
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    [self.view addGestureRecognizer:gesture];
    // Do any additional setup after loading the view from its nib.
}

- (void)hidenKeyboard
{
    [_messageTextView resignFirstResponder];
}

- (IBAction)uploadImageButtonClick:(id)sender
{
    [self selectPhotoPicker];
}
- (IBAction)sumitButtonClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (_type == CANCEL_ORDER) {
        if ([_messageTextView.text areAllCharactersSpace]) {
            [self displayHUDTitle:nil message:@"请输入文字!"];
            return;
        }
        if ([_messageTextView.text length] > 200) {
            [self displayHUDTitle:nil message:@"文字长度超过限制!"];
            return;
        }
        [self displayHUD:@"提交中..."];
        [btn setEnabled:NO];
        [[LZService shared] cancelOrder:_messageTextView.text
                                orderId:_oid
                              withBlock:^(NSDictionary *result, NSError *error) {
            [btn setEnabled:YES];
            if ([result isKindOfClass:[NSDictionary class]] && result) {
                if ([result[@"OrdState"] integerValue] == 1) {
                    [self displayHUDTitle:nil message:@"撤销成功!"];
                    [self performSelector:@selector(pushToRoot) withObject:nil afterDelay:1.0];
                } else {
                    [self displayHUDTitle:nil message:@"撤销失败!"];
                }
            } else {
                [self displayHUDTitle:nil message:@"撤销失败!"];
            }
        }];
    } else {
        if (_image == nil) {
            [self displayHUDTitle:nil message:@"请选择图片!"];
            return;
        }
        BOOL isSend = _type == SEND_ORDER;
        [self displayHUD:@"提交中..."];
        [btn setEnabled:NO];
        [[LZService shared] uploadImageWithType:isSend orderId:_oid image:_image orderNo:_orderNo withBlock:^(NSDictionary *result, NSError *error) {
            [btn setEnabled:YES];
            if (result && [result isKindOfClass:[NSDictionary class]]) {
                if ([result[@"OrdState"] integerValue] == 1) {
                    [self displayHUDTitle:nil message:@"操作成功!"];
                    [self performSelector:@selector(pushToRoot) withObject:nil afterDelay:1.0];
                } else {
                    [self displayHUDTitle:nil message:@"操作失败!"];
                }
            } else {
                [self displayHUDTitle:nil message:@"撤销失败!"];
            }
        }];
    }
}

- (void)pushToBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushToRoot
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)takePhoto
{
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
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
    _image = [self scaleToSize:CGSizeMake(500, 500) image:image];
    [_imageView setImage:_image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage*)scaleToSize:(CGSize)size image:(UIImage *)image
{
    CGFloat width = CGImageGetWidth(image.CGImage);
    CGFloat height = CGImageGetHeight(image.CGImage);
    
    float verticalRadio = size.height * 1.0/height;
    float horizontalRadio = size.width * 1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
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
