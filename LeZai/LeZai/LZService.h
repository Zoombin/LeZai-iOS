//
//  LZService.h
//  LeZai
//
//  Created by 颜超 on 14-2-11.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface LZService : AFHTTPClient
+ (instancetype)shared;

//订单查询
- (void)searchOrderByOrderNO:(NSString *)orederNo
                   withBlock:(void(^)(NSString *result))block;
@end
