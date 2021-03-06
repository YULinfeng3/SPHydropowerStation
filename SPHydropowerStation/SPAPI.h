//
//  SPAPI.h
//  SPHydropowerStation
//
//  Created by 余林峰 on 15/11/11.
//  Copyright © 2015年 SP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPUser.h"

@class SPAppInfo;

@interface SPAPI : NSObject

@property (nonatomic,retain) SPUser* currentUser;
@property (nonatomic,retain) NSString* appVersion;

+ (instancetype)sharedInstance;

+ (NSArray*)loadMenuItems;

+ (void)saveMenuItems:(NSArray*)menuItems;

- (void)loginWithUsername:(NSString*)username
                 password:(NSString*)password
                  succeed:(void (^)())succeed
                   failed:(void (^)(NSError* error))failed;

- (void)projListWithSucceed:(void (^)(NSArray* projList))succeed
                     failed:(void (^)(NSError* error))failed;

- (void)projDetailWithId:(NSString*)projId
                 succeed:(void (^)(SPProj* proj))succeed
                  failed:(void (^)(NSError* error))failed;

- (void)getProjImagesWithId:(NSString*)projId
                    succeed:(void (^)(NSArray* imageList))succeed
                     failed:(void (^)(NSError* error))failed;

- (void)appInfoSucceed:(void (^)(SPAppInfo* info))succeed
                failed:(void (^)(NSError* error))failed;

@end
