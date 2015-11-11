//
//  SPNetworkHelper.m
//  SPHydropowerStation
//
//  Created by 余林峰 on 15/11/11.
//  Copyright © 2015年 SP. All rights reserved.
//

#import "SPNetworkHelper.h"

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

@end
