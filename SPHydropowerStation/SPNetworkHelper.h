//
//  SPNetworkHelper.h
//  SPHydropowerStation
//
//  Created by 余林峰 on 15/11/11.
//  Copyright © 2015年 SP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPNetworkHelper : NSObject

+ (void)getWithUrl:(NSString*)url
            params:(NSDictionary*)params
           succeed:(void (^)(id data,NSInteger count))succeed
            failed:(void (^)(NSError* error))failed;

@end
