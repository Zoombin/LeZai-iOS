//
//  PCObject.h
//  LeZai
//
//  Created by 颜超 on 14-2-17.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCObject : NSObject

@property (nonatomic, strong) NSString *beginAreaName;
@property (nonatomic, strong) NSString *endAreaName;
@property (nonatomic, strong) NSString *kgPrice;
@property (nonatomic, strong) NSString *lmPrice;
@property (nonatomic, strong) NSString *minPrice;
@property (nonatomic, strong) NSString *beginDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *onWayTime;
@property (nonatomic, strong) NSString *busTime;
@property (nonatomic, strong) NSString *pushlishDate;

+ (NSArray *)createWithArray:(NSArray *)array;
+ (PCObject *)createWithDict:(NSDictionary *)dict;
@end
