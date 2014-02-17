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

#define BASE_URL @"http://www.lezaiwang.com/web/httphandle/"

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
    NSString *paramsString = [NSString stringWithFormat:@"{\"ToKen\":\"acf7ef943fdeb3cbfed8dd0d8f584731\",\"OrderNo\":\"%@\",\"ClientMode\":\"Ios\",\"UserName\":null,\"Password\":null}",orederNo];
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

@end
