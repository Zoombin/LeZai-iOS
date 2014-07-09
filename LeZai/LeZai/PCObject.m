//
//  PCObject.m
//  LeZai
//
//  Created by 颜超 on 14-2-17.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "PCObject.h"

@implementation PCObject
+ (NSArray *)createWithArray:(NSArray *)array
{
    NSMutableArray *pcArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dict = array[i];
        [pcArray addObject:[self createWithDict:dict]];
    }
    return pcArray;
}

+ (PCObject *)createWithDict:(NSDictionary *)dict
{
    PCObject *obj = [[PCObject alloc] init];
    obj.beginAreaName = dict[@"BeginAreaName"];
    obj.endAreaName = dict[@"EndAreaName"];
    obj.kgPrice = dict[@"KgPrice"];
    obj.lmPrice = dict[@"LmPrice"];
    obj.minPrice = dict[@"MinPrice"];
    obj.onWayTime = dict[@"OnWayTime"];
    obj.busTime = dict[@"BusTime"];
    obj.pushlishDate = dict[@"PublisDate"];
    obj.tPrice = dict[@"TPrice"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    NSDateFormatter *newformatter = [[NSDateFormatter alloc] init];
    [newformatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *beginDate = [formatter dateFromString:dict[@"BeginDate"]];
    NSDate *endDate = [formatter dateFromString:dict[@"EndDate"]];
    
    obj.beginDate = [newformatter stringFromDate:beginDate];
    obj.endDate = [newformatter stringFromDate:endDate];
    return obj;
}
@end
