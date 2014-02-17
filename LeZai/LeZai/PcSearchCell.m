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
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDateFormatter *newformatter = [[NSDateFormatter alloc] init];
    [newformatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *beginDate = [formatter dateFromString:dict[@"BeginDate"]];
    NSDate *endDate = [formatter dateFromString:dict[@"EndDate"]];
    
    [_resultTextView setText:[NSString stringWithFormat:@"始发地:%@\n目的地:%@\n运价（元）:%@/KG %@/m³ MIN:%@\n有效期:%@~%@\n时效:%@\n发车时间:%@\n发布时间:%@",dict[@"BeginAreaName"],dict[@"EndAreaName"],dict[@"KgPrice"],dict[@"LmPrice"],dict[@"MinPrice"],[newformatter stringFromDate:beginDate],[newformatter stringFromDate:endDate],dict[@"OnWayTime"],dict[@"BusTime"],dict[@"PublisDate"]]];
    NSLog(@"%@", _resultTextView.text);
}

@end
