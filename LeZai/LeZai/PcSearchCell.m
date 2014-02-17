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

- (void)updateInfo:(PCObject *)obj
{
    _startLocationLabel.text = [NSString stringWithFormat:@"始发地:%@",obj.beginAreaName];
    _endLocationLabel.text = [NSString stringWithFormat:@"目的地:%@",obj.endAreaName];
    _priceLabel.text = [NSString stringWithFormat:@"价格:%@/kg %@/m³ Min:%@",obj.kgPrice, obj.lmPrice, obj.minPrice];
    _beginAndEndLabel.text = [NSString stringWithFormat:@"有效期:%@ ~ %@", obj.beginDate, obj.endDate];
    _onWayTimeLabel.text = [NSString stringWithFormat:@"时效:%@", obj.onWayTime];
    _busTimeLabel.text = [NSString stringWithFormat:@"发车时间:%@", obj.busTime];
    _publisDate.text = [NSString stringWithFormat:@"发布日期:%@", obj.pushlishDate];
}

@end
