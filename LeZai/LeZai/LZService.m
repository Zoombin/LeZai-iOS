//
//  LZService.m
//  LeZai
//
//  Created by 颜超 on 14-2-11.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "LZService.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "SBJson.h"

//#define BASE_URL @"http://www.lezaiwang.com/web/httphandle/"
#define BASE_URL @"http://192.168.11.125/Cargo.Portal/web/httphandle/"

@implementation LZService
+(instancetype)shared
{
    static LZService *instance;
    if(!instance){
        instance = [[LZService alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        [instance registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    return instance;
}

- (NSString *)userToken
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN];
    return token;
}

- (void)saveUserToken:(NSString *)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:USER_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (id)jsonValue:(id)JSON
{
	if (![JSON isKindOfClass:[NSData class]] || !JSON) {
		return nil;
    }
    return [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableLeaves error:nil];
}

- (NSData *)byteArrayToData:(NSArray *)arr
{
    unsigned c = arr.count;
    uint8_t *bytes = (uint8_t*)malloc(sizeof(*bytes) * c);
    unsigned i;
    for (i = 0; i < c; i++) {
        NSString *str = [arr objectAtIndex:i];
        int byte = [str intValue];
        bytes[i] = (uint8_t)byte;
    }
    NSData *fileData = [NSData dataWithBytesNoCopy:bytes length:c freeWhenDone:YES];
    return fileData;
}

- (void)searchOrderByOrderNO:(NSString *)orederNo
                   withBlock:(void(^)(NSString *result))block
{
    UIDevice *device = [UIDevice currentDevice];//创建设备对象
    NSString *paramsString = [NSString stringWithFormat:@"{\"ToKen\":\"acf7ef943fdeb3cbfed8dd0d8f584731\",\"OrderNo\":\"%@\",\"ClientMode\":\"Ios\",\"ClientKey\":\"%@\"\"UserName\":null,\"Password\":null}",[[device identifierForVendor] UUIDString],orederNo];
    NSDictionary *params = @{@"ServiceName": @"OrderState", @"ServicePara": paramsString};

    [self getPath:@"szzwservice.ashx" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id theObject = [self jsonValue:responseObject];
        NSArray *byteArray = theObject[@"ReturnData"];
        if (byteArray && [byteArray isKindOfClass:[NSArray class]]) {
            NSString *str = [[NSString alloc]initWithData:[self byteArrayToData:byteArray] encoding:NSUTF8StringEncoding];
            if (block) {
                block(str);
            }
        } else {
            if (block) {
                block(@"未找到该订单");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil);
        }
    }];
}

- (void)pcSearchByStartCity:(NSString *)sCity
                    endCity:(NSString *)eCity
                   sendDate:(NSString *)sendDate
                       sort:(NSString *)sort
                       page:(int)page
                      count:(int)count
                  withBlock:(void (^)(NSArray *))block
{
    UIDevice *device = [UIDevice currentDevice];//创建设备对象
    if (!sCity) {
        sCity = @"";
    }
    if (!eCity) {
        eCity = @"";
    }
    if (!sendDate) {
        sendDate = @"";
    }
    NSString *paramsString = [NSString stringWithFormat:@"{\"Token\":\"acf7ef943fdeb3cbfed8dd0d8f584731\",\"ClientKey\":\"%@\",\"UserName\":null,\"Password\":null,\"ClientMode\":\"Ios\",\"OrderNo\":null,\"BeginCity\":\"%@\",\"EndCity\":\"%@\",\"SendDate\":\"%@\",\"OrderBy\":\"%@\",\"StartRows\":\"%d\",\"RecordRows\":\"%d\"}",[[device identifierForVendor] UUIDString],sCity,eCity,sendDate,sort,page,count];
    NSLog(@"%@", paramsString);
    NSDictionary *params = @{@"ServiceName": @"PcPriceSearch", @"ServicePara": paramsString};
    
    [self getPath:@"szzwservice.ashx" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id theObject = [self jsonValue:responseObject];
        NSArray *byteArray = theObject[@"ReturnData"];
        if (byteArray && [byteArray isKindOfClass:[NSArray class]]) {
            NSData *resultData = [self byteArrayToData:byteArray];
            if (block) {
                block([self jsonValue:resultData]);
            }
        } else {
            if (block) {
                block(nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil);
        }
    }];
}

- (void)orderListPage:(int)page count:(int)count WithBlock:(void(^)(NSArray *result, NSError *error))block
{
    UIDevice *device = [UIDevice currentDevice];//创建设备对象
    NSString *paramsString = [NSString stringWithFormat:@"{\"ToKen\":\"acf7ef943fdeb3cbfed8dd0d8f584731\",\"ClientKey\":\"%@\",\"StartRows\":\"%d\",\"RecordRows\":\"%d\",\"ClientMode\":\"Ios\",\"UserName\":null,\"Password\":null}", [[device identifierForVendor] UUIDString], page, count];
    NSDictionary *params = @{@"ServiceName": @"GetInterCityList", @"ServicePara": paramsString};
    
    [self getPath:@"szzwservice.ashx" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id theObject = [self jsonValue:responseObject];
        NSArray *byteArray = theObject[@"ReturnData"];
        if (byteArray && [byteArray isKindOfClass:[NSArray class]]) {
            NSData *resultData = [self byteArrayToData:byteArray];
            if (block) {
                block([self jsonValue:resultData], nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}


//版本检查
- (void)checkUpdateWithBlock:(void (^)(NSDictionary *result))block
{
    NSString *paramsString = [NSString stringWithFormat:@"{\"ToKen\":\"acf7ef943fdeb3cbfed8dd0d8f584731\",\"ClientMode\":\"Ios\",\"UserName\":null,\"Password\":null}"];
    NSDictionary *params = @{@"ServiceName": @"IosCheck", @"ServicePara": paramsString};
    
    [self getPath:@"szzwservice.ashx" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id theObject = [self jsonValue:responseObject];
        NSArray *byteArray = theObject[@"ReturnData"];
        if (byteArray && [byteArray isKindOfClass:[NSArray class]]) {
            NSData *resultData = [self byteArrayToData:byteArray];
            if (block) {
                block([self jsonValue:resultData]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil);
        }
    }];
}

- (void)loginOrRegister:(NSString *)userName
               password:(NSString *)password
                   type:(int)type
              withBlock:(void(^)(NSDictionary *result, NSError *error))block
{
    UIDevice *device = [UIDevice currentDevice];//创建设备对象
    NSString *paramsString = [NSString stringWithFormat:@"{\"ToKen\":\"acf7ef943fdeb3cbfed8dd0d8f584731\",\"ClientKey\":\"%@\",\"CarTelPhone\":\"%@\",\"CarTelCode\":\"%@\",\"LoginType\":\"%d\",\"ClientMode\":\"Ios\",\"UserName\":null,\"Password\":null}", [[device identifierForVendor] UUIDString], userName, password,type];
    NSDictionary *params = @{@"ServiceName": @"CarCheck", @"ServicePara": paramsString};
    
    [self getPath:@"szzwservice.ashx" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id theObject = [self jsonValue:responseObject];
        NSArray *byteArray = theObject[@"ReturnData"];
        if (byteArray && [byteArray isKindOfClass:[NSArray class]]) {
            NSData *resultData = [self byteArrayToData:byteArray];
            if (block) {
                block([self jsonValue:resultData], nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

//UserCarCode

- (void)orderInfo:(NSString *)orderId withBlock:(void (^)(NSArray *, NSError *))block
{
    UIDevice *device = [UIDevice currentDevice];//创建设备对象
    NSString *paramsString = [NSString stringWithFormat:@"{\"ToKen\":\"acf7ef943fdeb3cbfed8dd0d8f584731\",\"ClientKey\":\"%@\",\"OrdOid\":\"%@\",\"ClientMode\":\"Ios\",\"UserName\":null,\"Password\":null}", [[device identifierForVendor] UUIDString], orderId];
    NSDictionary *params = @{@"ServiceName": @"GetInterCityListInfo", @"ServicePara": paramsString};
    
    [self getPath:@"szzwservice.ashx" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id theObject = [self jsonValue:responseObject];
        NSArray *byteArray = theObject[@"ReturnData"];
        if (byteArray && [byteArray isKindOfClass:[NSArray class]]) {
            NSData *resultData = [self byteArrayToData:byteArray];
            if (block) {
                block([self jsonValue:resultData], nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)addOrder:(NSString *)orderId
           price:(NSString *)price
       withBlock:(void (^)(NSDictionary *result, NSError *error))block
{
    UIDevice *device = [UIDevice currentDevice];//创建设备对象
    NSString *paramsString = [NSString stringWithFormat:@"{\"ToKen\":\"acf7ef943fdeb3cbfed8dd0d8f584731\",\"ClientKey\":\"%@\",\"OrdOid\":\"%@\",\"Price\":\"%@\",\"UserCarCode\":\"%@\",\"ClientMode\":\"Ios\",\"UserName\":null,\"Password\":null}", [[device identifierForVendor] UUIDString], orderId, price, [self userToken]];
    NSDictionary *params = @{@"ServiceName": @"GetInterCityListAdd", @"ServicePara": paramsString};
    
    [self getPath:@"szzwservice.ashx" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id theObject = [self jsonValue:responseObject];
        NSArray *byteArray = theObject[@"ReturnData"];
        if (byteArray && [byteArray isKindOfClass:[NSArray class]]) {
            NSData *resultData = [self byteArrayToData:byteArray];
            if (block) {
                block([self jsonValue:resultData], nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)getOrderList:(int)type
                page:(int)page
               count:(int)count
           withBlock:(void (^)(NSArray *result, NSError *error))block
{
    //    GetInterCityListPick   等待提货
    //    GetInterCityListIng    等待确认
    //    GetInterCityListSend   等待收货
    //    GetInterCityListCommit 订单完成
    //    GetInterCityListBack   撤销列表
    
    NSArray *serviceName = @[@"GetInterCityListIng", @"GetInterCityListPick" ,@"GetInterCityListSend", @"GetInterCityListCommit", @"GetInterCityListBack"];
    UIDevice *device = [UIDevice currentDevice];//创建设备对象
    NSString *paramsString = [NSString stringWithFormat:@"{\"ToKen\":\"acf7ef943fdeb3cbfed8dd0d8f584731\",\"ClientKey\":\"%@\",\"UserCarCode\":\"%@\",\"ClientMode\":\"Ios\",\"StartRows\":\"%d\",\"RecordRows\":\"%d\",\"UserName\":null,\"Password\":null}", [[device identifierForVendor] UUIDString], [self userToken], page, count];
    NSDictionary *params = @{@"ServiceName": serviceName[type - 1], @"ServicePara": paramsString};
    
    [self getPath:@"szzwservice.ashx" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id theObject = [self jsonValue:responseObject];
        NSArray *byteArray = theObject[@"ReturnData"];
        if (byteArray && [byteArray isKindOfClass:[NSArray class]]) {
            NSData *resultData = [self byteArrayToData:byteArray];
            if (block) {
                block([self jsonValue:resultData], nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)cancelOrder:(NSString *)message
          withBlock:(void (^)(NSDictionary *result, NSError *error))block
{
//    512字符
    UIDevice *device = [UIDevice currentDevice];//创建设备对象
    NSString *paramsString = [NSString stringWithFormat:@"{\"ToKen\":\"acf7ef943fdeb3cbfed8dd0d8f584731\",\"ClientKey\":\"%@\",\"UserCarCode\":\"%@\",\"Message\":\"%@\",\"ClientMode\":\"Ios\",\"UserName\":null,\"Password\":null}", [[device identifierForVendor] UUIDString], [self userToken], message];
    NSDictionary *params = @{@"ServiceName" : @"GetInterCityListBackCommit", @"ServicePara": paramsString};
    
    [self getPath:@"szzwservice.ashx" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id theObject = [self jsonValue:responseObject];
        NSArray *byteArray = theObject[@"ReturnData"];
        if (byteArray && [byteArray isKindOfClass:[NSArray class]]) {
            NSData *resultData = [self byteArrayToData:byteArray];
            if (block) {
                block([self jsonValue:resultData], nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)uploadImageWithType:(BOOL)isSendGoods
                    orderId:(NSString *)orderId
                      image:(UIImage *)image
                    orderNo:(NSString *)orderNO
                  withBlock:(void (^)(NSDictionary *result, NSError *error))block
{
    NSString *fileName = [NSString stringWithFormat:@"%@%@.png", orderNO,isSendGoods ? @"送货" : @"提货"];
    NSString *serviceName = isSendGoods ? @"GetInterCityListSendCommit" : @"GetInterCityListPickCommit";
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    NSString *fileBase64 = [imageData base64Encoding];
    NSString *operuser = @"13862090556";
    NSString *orderOid = orderId; //Oid
    
    NSMutableDictionary *picInfo = [[NSMutableDictionary alloc] init];
    picInfo[@"filename"] = fileName;
    picInfo[@"filedata"] = fileBase64;
    picInfo[@"operuser"] = operuser;
    picInfo[@"Ordoid"] = orderOid;
    
    NSString *picString = [picInfo JSONRepresentation];
    
    UIDevice *device = [UIDevice currentDevice];//创建设备对象
    NSString *paramsString = [NSString stringWithFormat:@"{\"ToKen\":\"acf7ef943fdeb3cbfed8dd0d8f584731\",\"ClientKey\":\"%@\",\"UserCarCode\":\"%@\",\"ClientMode\":\"Ios\",\"PicInfo\":\"%@\",\"PicName\":\"%@\",\"CarTelPhone\":\"%@\",\"OrdOid\":\"%@\",\"UserName\":null,\"Password\":null}", [[device identifierForVendor] UUIDString], [self userToken], fileBase64, fileName, operuser, orderOid];
    NSDictionary *params = @{@"ServiceName": serviceName, @"ServicePara": paramsString};
    
    [self postPath:@"szzwservice.ashx" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id theObject = [self jsonValue:responseObject];
        NSArray *byteArray = theObject[@"ReturnData"];
        if (byteArray && [byteArray isKindOfClass:[NSArray class]]) {
            NSData *resultData = [self byteArrayToData:byteArray];
            if (block) {
                block([self jsonValue:resultData], nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}
@end
