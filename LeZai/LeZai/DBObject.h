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
@property (nonatomic, strong) NSString *status; //状态
@property (nonatomic, strong) NSString *statusName; 
@property (nonatomic, strong) NSString *carSize; //车型要求
@property (nonatomic, strong) NSString *orderOid; //订单id
@property (nonatomic, strong) NSString *orderInfo;
@property (nonatomic, strong) NSString *oid;
@property (nonatomic, strong) NSString *oidNo;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *orderPrice; //我的抢单金额
@property (nonatomic, strong) NSString *listState;
@property (nonatomic, strong) NSString *shortOrderNo; //显示给用户看的
@property (nonatomic, strong) NSString *note; //是否显示按钮 false

+ (DBObject *)createDBObjectWithDict:(NSDictionary *)dict;
+ (NSArray *)createDBObjectsWithArray:(NSArray *)array;
@end
