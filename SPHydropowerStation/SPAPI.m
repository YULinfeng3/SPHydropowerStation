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
#import "SPUser.h"
#import "SPProj.h"

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
    
    WS(weakSelf);
    [SPNetworkHelper getWithUrl:url params:nil succeed:^(id data, NSInteger count) {
        MAIN(^{
            if ([data isEqualToString:@"true"]) {
                [SPAPI sharedInstance].currentUser = [[SPUser alloc] init];
                [SPAPI sharedInstance].currentUser.account = username;
                [weakSelf userIdWithAccount:username succeed:^(NSString *userID) {
                    [SPAPI sharedInstance].currentUser.userID = userID;
                    
                    [weakSelf defaultProjWithUserId:userID succeed:^(NSDictionary* data){
                        if ([userID isEqualToString:data[@"UserID"]]) {
                            NSString* projId = data[@"LoginProj"];
                            [weakSelf projDetailWithId:projId succeed:^(SPProj *proj) {
                                [SPAPI sharedInstance].currentUser.defaultProj = proj;
                                succeed();
                            } failed:^(NSError *error) {
                               succeed();
                            }];
                        }else{
                            succeed();
                        }
                    } failed:^(NSError *error) {
                        failed(nil);
                    }];
                } failed:^(NSError *error) {
                    failed(error);
                }];
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

- (void)defaultProjWithUserId:(NSString*)userId
                       succeed:(void (^)(NSDictionary* data))succeed
                        failed:(void (^)(NSError* error))failed{
    NSString* url = [NSString stringWithFormat:@"http://221.12.173.120/WisdomService/api/Values/Get_DefUser?key=ecidi123456&userID=%@",userId];
    [SPNetworkHelper getWithUrl:url params:nil succeed:^(id data, NSInteger count) {
        MAIN(^{
            NSString* str = data;
            NSData* jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSArray* array = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            if (array.count > 0) {
                succeed(array[0]);
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

- (void)userIdWithAccount:(NSString*)account
                  succeed:(void (^)(NSString* userID))succeed
                   failed:(void (^)(NSError* error))failed{
    NSString* url = [NSString stringWithFormat:@"http://221.12.173.120/WisdomService/api/Values/GetUserIdByAccount?key=ecidi123456&account=%@",account];
    
    [SPNetworkHelper getWithUrl:url params:nil succeed:^(id data, NSInteger count) {
        MAIN(^{
            NSString* userID = [data stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            succeed(userID);
        });
    } failed:^(NSError *error) {
        MAIN(^{
            failed(error);
        });
    }];
}

- (void)projListWithSucceed:(void (^)(NSArray* projList))succeed
                     failed:(void (^)(NSError* error))failed{
    NSString* url = [NSString stringWithFormat:@"http://221.12.173.120/WisdomService/api/Values/GetUserProjs?key=ecidi123456&userID=%@",[SPAPI sharedInstance].currentUser.userID];
    
    [SPNetworkHelper getWithUrl:url params:nil succeed:^(id data, NSInteger count) {
        MAIN(^{
            NSString* str = data;
            NSData* jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSArray* array = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            NSMutableArray* projList = [NSMutableArray array];
            for (NSDictionary* item in array) {
                SPProj* model = [SPProj projWithJSON:item];
                [projList addObject:model];
            }
            succeed(projList);
        });
    } failed:^(NSError *error) {
        MAIN(^{
            failed(error);
        });
    }];
}

- (void)projDetailWithId:(NSString*)projId
                 succeed:(void (^)(SPProj* proj))succeed
                  failed:(void (^)(NSError* error))failed{
    NSString* url = [NSString stringWithFormat:@"http://221.12.173.120/WisdomService/api/Values/Get_Proj?key=ecidi123456&projID=%@",projId];
    [SPNetworkHelper getWithUrl:url params:nil succeed:^(id data, NSInteger count) {
        MAIN(^{
            NSString* str = data;
            NSData* jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSArray* array = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            NSDictionary* data = nil;
            if (array && array.count > 0) {
                data = array[0];
            }
            SPProj* model = [SPProj projWithJSON:data];
            succeed(model);
        });
    } failed:^(NSError *error) {
        MAIN(^{
            failed(error);
        });
    }];
}

- (void)getProjImagesWithId:(NSString*)projId
                    succeed:(void (^)(NSArray* imageList))succeed
                     failed:(void (^)(NSError* error))failed{
    NSString* url = [NSString stringWithFormat:@"http://221.12.173.120/WisdomService/api/Values/GetProjPictures?key=ecidi123456&projID=%@",projId];
    [SPNetworkHelper getWithUrl:url params:nil succeed:^(id data, NSInteger count) {
        MAIN(^{
            NSString* str = data;
            NSData* jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSArray* array = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            
            succeed(array);
        });
    } failed:^(NSError *error) {
        MAIN(^{
            failed(error);
        });
    }];
}

@end
