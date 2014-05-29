//
//  DBObject.h
//  LeZai
//
//  Created by 颜超 on 14-5-24.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBObject : NSObject

@property (nonatomic, strong) NSString *departure; //出发地
@property (nonatomic, strong) NSString *destination; //目的地
@property (nonatomic, strong) NSString *finishDate; //到货时间
@property (nonatomic, strong) NSString *submitDate; //发布时间
@property (nonatomic, strong) NSString *getDate; //提货时间
@property (nonatomic, strong) NSString *status; //状态 这个不需要了
@property (nonatomic, strong) NSString *carSize; //车型要求
@property (nonatomic, strong) NSString *orderId; //订单id

- (DBObject *)createDBObjectWithDict:(NSDictionary *)dict;
- (NSArray *)createDBObjectsWithArray:(NSArray *)array;
@end
