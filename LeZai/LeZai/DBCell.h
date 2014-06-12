//
//  DBCell.h
//  LeZai
//
//  Created by 颜超 on 14-5-21.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBObject.h"

@interface DBCell : UITableViewCell

@property (nonatomic, strong) DBObject *duanBo;
@property (nonatomic, weak) IBOutlet UILabel *startLocationLabel;
@property (nonatomic, weak) IBOutlet UILabel *destinationLabel;
@property (nonatomic, weak) IBOutlet UILabel *finishDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *submitLabel;
@end
