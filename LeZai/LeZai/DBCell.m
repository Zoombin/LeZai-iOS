//
//  DBCell.m
//  LeZai
//
//  Created by 颜超 on 14-5-21.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "DBCell.h"

@implementation DBCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)height
{
    return 170;
}

- (void)setDuanBo:(DBObject *)duanBo
{
    _infoTextView.text = [NSString stringWithFormat:@"订单号:%@\n始发地:%@\n目的地:%@\n提货日期:%@\n订单金额:%@\n发布时间:%@\n",duanBo.shortOrderNo, duanBo.departure, duanBo.destination, duanBo.finishDate,duanBo.price, duanBo.submitDate];
    
    _startLocationLabel.text = duanBo.departure;
    _destinationLabel.text = duanBo.destination;
    _finishDateLabel.text = duanBo.finishDate;
    _priceLabel.text = [NSString stringWithFormat:@"%@", duanBo.price];
    _submitLabel.text = duanBo.submitDate;
    _orderNoLabel.text = duanBo.shortOrderNo;
}

@end
