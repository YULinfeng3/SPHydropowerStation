//
//  SPAPI.h
//  SPHydropowerStation
//
//  Created by 余林峰 on 15/11/11.
//  Copyright © 2015年 SP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPUser.h"

@interface SPAPI : NSObject

@property (nonatomic,retain) SPUser* currentUser;

+ (instancetype)sharedInstance;

- (void)loginWithUsername:(NSString*)username
                 password:(NSString*)password
                  succeed:(void (^)())succeed
                   failed:(void (^)(NSError* error))failed;

- (void)projListWithSucceed:(void (^)(NSArray* projList))succeed
                     failed:(void (^)(NSError* error))failed;

@end
