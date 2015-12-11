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
#import "SPMenuItem.h"

@implementation SPAPI

+ (instancetype)sharedInstance{
    static SPAPI* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SPAPI alloc] init];
    });
    
    return sharedInstance;
}

+ (NSArray*)loadMenuItems{
    NSArray* menuItems = [[NSUserDefaults standardUserDefaults] objectForKey:@"menuItems"];
    
    if (menuItems) {
        NSMutableArray* temp = [NSMutableArray array];
        for (NSDictionary* item in menuItems) {
            SPMenuItem* model = [SPMenuItem menuWithJSON:item];
            [temp addObject:model];
        }
        return [NSArray arrayWithArray:temp];
    }else{
        // 第一次初始化
        NSArray* data = @[@{@"title":@"切换项目",@"imageName":@"qhxm",@"show":@(YES)},
                          @{@"title":@"综合展示",@"imageName":@"zhzs",@"show":@(YES)},
                          @{@"title":@"工程简介",@"imageName":@"gcjj",@"show":@(YES)},
                          @{@"title":@"厂房3D",@"imageName":@"cf3d",@"show":@(YES)},
                          @{@"title":@"资源监控",@"imageName":@"zyjk",@"show":@(YES)},
                          @{@"title":@"混凝土监控",@"imageName":@"hntjk",@"show":@(YES)},
                          @{@"title":@"大数据分析",@"imageName":@"4",@"show":@(YES)},
                          @{@"title":@"系统管理",@"imageName":@"xtgl",@"show":@(YES)},
                          
                          @{@"title":@"碾压监控",@"imageName":@"nyjk",@"show":@(NO)},
                          @{@"title":@"验收管理",@"imageName":@"ysgl",@"show":@(NO)},
                          @{@"title":@"视频监控",@"imageName":@"spjk",@"show":@(NO)},
                          @{@"title":@"现场巡检",@"imageName":@"xcxj",@"show":@(NO)},
                          @{@"title":@"安全监测",@"imageName":@"aqjc",@"show":@(NO)},
                          @{@"title":@"档案管理",@"imageName":@"dagl",@"show":@(NO)},
                          @{@"title":@"施工面貌",@"imageName":@"10",@"show":@(NO)},
                           @{@"title":@"进度监控",@"imageName":@"10",@"show":@(NO)},
                           @{@"title":@"成本监控",@"imageName":@"10",@"show":@(NO)}];
        
        NSMutableArray* menuList = [NSMutableArray array];
        for (NSDictionary* item in data) {
            SPMenuItem* model = [SPMenuItem menuWithJSON:item];
            [menuList addObject:model];
        }
        
        return [NSArray arrayWithArray:menuList];
    }
    
    
    return nil;
}

+ (void)saveMenuItems:(NSArray*)menuItems{
    NSMutableArray* temp = [NSMutableArray array];
    for (SPMenuItem* item in menuItems) {
        NSDictionary* d = [item dictionaryProxy];
        [temp addObject:d];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:temp forKey:@"menuItems"];
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
