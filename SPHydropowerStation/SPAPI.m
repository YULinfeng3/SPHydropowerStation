//
//  SPAPI.m
//  SPHydropowerStation
//
//  Created by 余林峰 on 15/11/11.
//  Copyright © 2015年 SP. All rights reserved.
//

#import "SPAPI.h"
#import "SPNetworkHelper.h"
#import "MacroDefinition.h"

@implementation SPAPI

+ (instancetype)sharedInstance{
    static SPAPI* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SPAPI alloc] init];
    });
    
    return sharedInstance;
}

- (void)loginWithUsername:(NSString*)username
                 password:(NSString*)password
                  succeed:(void (^)())succeed
                   failed:(void (^)(NSError* error))failed{
    NSString* url = [NSString stringWithFormat:@"http://221.12.173.120/WisdomService/api/Values/CanAccountLogin?key=ecidi123456&account=%@&pwd=%@",username,password];
    
    [SPNetworkHelper getWithUrl:url params:nil succeed:^(id data, NSInteger count) {
        MAIN(^{
            if ([data isEqualToString:@"true"]) {
                succeed();
            }else{
                failed(nil);
            }
        });
    } failed:^(NSError *error) {
        MAIN(^{
            failed(error);
        });
    }];
}

@end
