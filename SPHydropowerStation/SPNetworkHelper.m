//
//  SPNetworkHelper.m
//  SPHydropowerStation
//
//  Created by 余林峰 on 15/11/11.
//  Copyright © 2015年 SP. All rights reserved.
//

#import "SPNetworkHelper.h"
#import <AFNetworking.h>

@implementation SPNetworkHelper

+ (void)getWithUrl:(NSString*)url
            params:(NSDictionary*)params
           succeed:(void (^)(id data,NSInteger count))succeed
            failed:(void (^)(NSError* error))failed{
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];//通过URL创建网络请求
    [request setTimeoutInterval:30];//设置超时时间
    [request setHTTPMethod:@"GET"];//设置请求方式
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            failed(nil);
        }else{
            NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            succeed(str,0);
        }
    }];
}

+ (void)get2WithUrl:(NSString*)url
            params:(NSDictionary*)params
           succeed:(void (^)(id data,NSInteger count))succeed
            failed:(void (^)(NSError* error))failed{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager.requestSerializer setTimeoutInterval:30];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [manager.requestSerializer setValue:version forHTTPHeaderField:@"version"];
    
    NSDictionary *dict =@{@"format":@"xml"};
    [manager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 200)
        {
            // 保存"Set-Cookie"
            NSDictionary* header = operation.response.allHeaderFields;
            NSString* cookie = header[@"Set-Cookie"];
            if (cookie) {
                [[NSUserDefaults standardUserDefaults] setObject:cookie forKey:@"Cookie"];
            }
            
            NSString* token = header[@"token"];
            if (token) {
                [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
            }
            
            id result = responseObject[@"result"];
            if ([result isKindOfClass:[NSDictionary class]] ||
                [result isKindOfClass:[NSArray class]])
            {
                if (responseObject[@"count"]) {
                    succeed(result,[responseObject[@"count"] integerValue]);
                }else{
                    succeed(result,0);
                }
            }
            else if ([result isKindOfClass:[NSString class]])
            {
                NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
                id object = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
                succeed(object,[responseObject[@"count"] integerValue]);
            }
            else
            {
                succeed(responseObject,0);
            }
        }
        else if (code == -100)
        {
            // 需要重新登录
            NSArray* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
            for (NSHTTPCookie *cookie in cookies)
            {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            }
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Cookie"];
            failed(nil);
        }
        else
        {
            failed([NSError errorWithDomain:@"Catch" code:[responseObject[@"code"] integerValue] userInfo:responseObject]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [CATCommonHelper showMessage:NSLocalizedString(@"Network error", nil)];
        
        failed(error);
    }];
}

@end
