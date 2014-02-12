//
//  PcSearchCell.m
//  LeZai
//
//  Created by 颜超 on 14-2-12.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "PcSearchCell.h"

@implementation PcSearchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateInfo:(NSDictionary *)dict
{
    [_resultTextView setText:[NSString stringWithFormat:@"始发地:%@\n目的地:%@\n运价（元）:%@/公斤 %@/立方 最低运价:%@\n有效期:%@~%@\n时效:%@\n发车时间:%@\n发布时间:%@",dict[@"BeginAreaName"],dict[@"EndAreaName"],dict[@"KgPrice"],dict[@"LmPrice"],dict[@"MinPrice"],dict[@"BeginDate"],dict[@"EndDate"],dict[@"OnWayTime"],dict[@"BusTime"],dict[@"PublisDate"]]];
}

@end
