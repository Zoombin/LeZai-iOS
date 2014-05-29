//
//  DBObject.m
//  LeZai
//
//  Created by 颜超 on 14-5-24.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "DBObject.h"

@implementation DBObject

- (DBObject *)createDBObjectWithDict:(NSDictionary *)dict
{
    DBObject *obj = [[DBObject alloc] init];
    obj.orderId = dict[@""];
    obj.departure = dict[@""];
    obj.destination = dict[@""];
    obj.submitDate = dict[@""];
    obj.getDate = dict[@""];
    obj.finishDate = dict[@""];
    obj.carSize = dict[@""];
    return obj;
}

- (NSArray *)createDBObjectsWithArray:(NSArray *)array
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < [array count]; i ++) {
        DBObject *obj = [self createDBObjectWithDict:array[i]];
        [arr addObject:obj];
    }
    return arr;
}
@end
