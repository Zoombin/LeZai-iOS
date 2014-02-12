//
//  PcSearchCell.h
//  LeZai
//
//  Created by 颜超 on 14-2-12.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PcSearchCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UITextView *resultTextView;
- (void)updateInfo:(NSDictionary *)dict;
@end
