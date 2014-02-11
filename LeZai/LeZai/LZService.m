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

- (void)searchOrderByOrderNO:(NSString *)orederNo
                   withBlock:(void(^)(NSString *result))block
{
    NSString *paramsString = [NSString stringWithFormat:@"{\"ToKen\":\"acf7ef943fdeb3cbfed8dd0d8f584731\",\"OrderNo\":\"%@\",\"ClientMode\":\"Android\",\"UserName\":null,\"Password\":null}",orederNo];
    NSDictionary *params = @{@"ServiceName": @"OrderState", @"ServicePara": paramsString};

    [self getPath:@"szzwservice.ashx" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id theObject = [self jsonValue:responseObject];
        NSArray *byteArray = theObject[@"ReturnData"];
        if (byteArray && [byteArray isKindOfClass:[NSArray class]]) {
            unsigned c = byteArray.count;
            uint8_t *bytes = (uint8_t*)malloc(sizeof(*bytes) * c);
            unsigned i;
            for (i = 0; i < c; i++) {
                NSString *str = [byteArray objectAtIndex:i];
                int byte = [str intValue];
                bytes[i] = (uint8_t)byte;
            }
            NSData *fileData = [NSData dataWithBytesNoCopy:bytes length:c freeWhenDone:YES];
            NSString *str = [[NSString alloc]initWithData:fileData encoding:NSUTF8StringEncoding];
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

@end
