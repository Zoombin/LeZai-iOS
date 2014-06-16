//
//  LZService.h
//  LeZai
//
//  Created by 颜超 on 14-2-11.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

#define USER_TOKEN @"user_token"
#define ORDER_ORDERING 1
#define ORDER_PICK 2
#define ORDER_SEND 3
#define ORDER_FINISH 4
#define ORDER_CANCEL 5

#define I_AM_DRIVER @"driver"
#define I_AM_CUSTOMER @"custom"
#define ROLE_KEY    @"role"
#define START_LOCATION_KEY @"startlocation"
#define END_LOCATION_KEY @"endlocation"

@interface LZService : AFHTTPClient
+ (instancetype)shared;
- (NSString *)userToken;
- (void)saveUserToken:(NSString *)token;
- (void)saveRole:(NSString *)role;
- (void)signOut;
- (NSString *)userRole;
- (void)saveStartLocation:(NSString *)start;
- (void)saveEndLocation:(NSString *)end;
- (NSString *)startLocation;
- (NSString *)endLocation;

//订单查询
- (void)searchOrderByOrderNO:(NSString *)orederNo
                   withBlock:(void(^)(NSString *result))block;

//拼车查询
- (void)pcSearchByStartCity:(NSString *)sCity
                    endCity:(NSString *)eCity
                   sendDate:(NSString *)sendDate
                       sort:(NSString *)sort
                       page:(int)page
                      count:(int)count
                  withBlock:(void(^)(NSArray *result))block;

//订单列表
- (void)orderListPage:(int)page
                count:(int)count
           WithBlock:(void(^)(NSArray *result, NSError *error))block;

//版本检查
- (void)checkUpdateWithBlock:(void(^)(NSDictionary *result))block;

//注册或者登陆
- (void)loginOrRegister:(NSString *)userName
               password:(NSString *)password
                   type:(int)type //0注册 1登录
              withBlock:(void(^)(NSDictionary *result, NSError *error))block;

//订单详情
- (void)orderInfo:(NSString *)orderId
        withBlock:(void(^)(NSArray *result, NSError *error))block;

//下订单
- (void)addOrder:(NSString *)orderId
           price:(NSString *)price
       withBlock:(void (^)(NSDictionary *result, NSError *error))block;

//已竞单
- (void)getOrderList:(int)type
                page:(int)page
               count:(int)count
           withBlock:(void (^)(NSArray *result, NSError *error))block;

//撤销
- (void)cancelOrder:(NSString *)message
            orderId:(NSString *)oid
          withBlock:(void (^)(NSDictionary *result, NSError *error))block;

//收货和提货
- (void)uploadImageWithType:(BOOL)isSendGoods orderId:(NSString *)orderId image:(UIImage *)image orderNo:(NSString *)orderNO withBlock:(void (^)(NSDictionary *result, NSError *error))block;

@end
