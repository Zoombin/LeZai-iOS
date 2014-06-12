//
//  DBDetailViewController.h
//  LeZai
//
//  Created by 颜超 on 14-5-24.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBDetailViewController : UIViewController<UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *startLocationLabel;
@property (nonatomic, weak) IBOutlet UILabel *endLocationLabel;
@property (nonatomic, weak) IBOutlet UILabel *finishDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *submitLabel;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, weak) IBOutlet UITextView *goodInfoTextView;
- (IBAction)orderButtonClick:(id)sender;
- (IBAction)pickButtonClick:(id)sender;
- (IBAction)sendButtonClick:(id)sender;
- (IBAction)cancelButtonClick:(id)sender;
@end


