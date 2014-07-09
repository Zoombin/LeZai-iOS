//
//  PcSearchCell.h
//  LeZai
//
//  Created by 颜超 on 14-2-12.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCObject.h"

@interface PcSearchCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *startLocationLabel;
@property (nonatomic, weak) IBOutlet UILabel *endLocationLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
//@property (nonatomic, weak) IBOutlet UILabel *beginAndEndLabel;
//@property (nonatomic, weak) IBOutlet UILabel *onWayTimeLabel;
//@property (nonatomic, weak) IBOutlet UILabel *busTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *publisDate;

- (void)updateInfo:(PCObject *)dict;
@end
