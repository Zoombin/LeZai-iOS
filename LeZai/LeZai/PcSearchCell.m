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
    _startLocationLabel.text = [NSString stringWithFormat:@"%@",obj.beginAreaName];
    _endLocationLabel.text = [NSString stringWithFormat:@"%@",obj.endAreaName];
    
    _priceLabel.text = [NSString stringWithFormat:@"%@/kg %@/t %@/m³ Min:%@",obj.kgPrice, obj.tPrice,obj.lmPrice, obj.minPrice];
    _publisDate.text = [NSString stringWithFormat:@"%@", obj.pushlishDate];
}

@end
