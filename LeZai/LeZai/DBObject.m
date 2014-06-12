//
//  DBObject.m
//  LeZai
//
//  Created by 颜超 on 14-5-24.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "DBObject.h"

@implementation DBObject

+ (DBObject *)createDBObjectWithDict:(NSDictionary *)dict
{
    DBObject *obj = [[DBObject alloc] init];
    obj.orderOid = dict[@"OrdOid"];
    obj.oidNo = dict[@"OrdNo"];
    obj.oid = dict[@"Oid"];
    obj.departure = dict[@"PickSendAddress"];
    obj.destination = dict[@"SendAddress"];
    obj.submitDate = [self getCorrectDate:dict[@"Inserttime"]];
    obj.finishDate = [self getCorrectDate:dict[@"PicSendTime"]];
    obj.orderInfo = dict[@"DcjetCloneEntity"][@"OrderNameInfo"];
    obj.price = dict[@"Price"];
    obj.status = dict[@"DcjetCloneEntity"][@"State"];
    if ([obj.status isEqualToString:@"B"]) {
        obj.statusName = @"等待接单";
    } else if ([obj.status isEqualToString:@"C"]) {
        obj.statusName = @"接单成功";
    } else if ([obj.status isEqualToString:@"E"]) {
        obj.statusName = @"确定提货";
    } else if ([obj.status isEqualToString:@"F"]) {
        obj.statusName = @"订单完成";
    }
    return obj;
}

+ (NSArray *)createDBObjectsWithArray:(NSArray *)array
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < [array count]; i ++) {
        DBObject *obj = [self createDBObjectWithDict:array[i]];
        [arr addObject:obj];
    }
    return arr;
}

+ (NSString *)getCorrectDate:(NSString *)str
{
    NSString *timeStr = str;
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"+0800)/" withString:@""];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]/1000];
    return [dateFormatter stringFromDate:date];
}
@end
